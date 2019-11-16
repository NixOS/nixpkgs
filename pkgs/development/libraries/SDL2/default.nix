{ stdenv, config, fetchurl, pkgconfig
, libGLSupported ? stdenv.lib.elem stdenv.hostPlatform.system stdenv.lib.platforms.mesaPlatforms
, openglSupport ? libGLSupported, libGL
, alsaSupport ? stdenv.isLinux && !stdenv.hostPlatform.isAndroid, alsaLib
, x11Support ? !stdenv.isCygwin && !stdenv.hostPlatform.isAndroid
, libX11, xorgproto, libICE, libXi, libXScrnSaver, libXcursor
, libXinerama, libXext, libXxf86vm, libXrandr
, waylandSupport ? stdenv.isLinux && !stdenv.hostPlatform.isAndroid
, wayland, wayland-protocols, libxkbcommon
, dbusSupport ? stdenv.isLinux && !stdenv.hostPlatform.isAndroid, dbus
, udevSupport ? false, udev
, ibusSupport ? false, ibus
, fcitxSupport ? false, fcitx
, pulseaudioSupport ? config.pulseaudio or stdenv.isLinux && !stdenv.hostPlatform.isAndroid
, libpulseaudio
, AudioUnit, Cocoa, CoreAudio, CoreServices, ForceFeedback, OpenGL
, audiofile, libiconv
}:

# NOTE: When editing this expression see if the same change applies to
# SDL expression too

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "SDL2";
  version = "2.0.10";

  src = fetchurl {
    url = "https://www.libsdl.org/release/${pname}-${version}.tar.gz";
    sha256 = "0mqxp6w5jhbq6y1j690g9r3gpzwjxh4czaglw8x05l7hl49nqrdl";
  };

  outputs = [ "out" "dev" ];
  outputBin = "dev"; # sdl-config

  patches = [ ./find-headers.patch ];

  # Fix with mesa 19.2: https://bugzilla.libsdl.org/show_bug.cgi?id=4797
  postPatch = ''
    substituteInPlace include/SDL_opengl_glext.h \
      --replace "typedef ptrdiff_t GLsizeiptr;" "typedef signed long int khronos_ssize_t; typedef khronos_ssize_t GLsizeiptr;" \
      --replace "typedef ptrdiff_t GLintptr;" "typedef signed long int khronos_intptr_t; typedef khronos_intptr_t GLintptr;"
  '';

  nativeBuildInputs = [ pkgconfig ];

  propagatedBuildInputs = dlopenPropagatedBuildInputs;

  dlopenPropagatedBuildInputs = [ ]
    # Propagated for #include <GLES/gl.h> in SDL_opengles.h.
    ++ optional openglSupport libGL
    # Propagated for #include <X11/Xlib.h> and <X11/Xatom.h> in SDL_syswm.h.
    ++ optionals x11Support [ libX11 xorgproto ];

  dlopenBuildInputs = [ ]
    ++ optionals  alsaSupport [ alsaLib audiofile ]
    ++ optional  dbusSupport dbus
    ++ optional  pulseaudioSupport libpulseaudio
    ++ optional  udevSupport udev
    ++ optionals waylandSupport [ wayland wayland-protocols libxkbcommon ]
    ++ optionals x11Support [ libICE libXi libXScrnSaver libXcursor libXinerama libXext libXrandr libXxf86vm ];

  buildInputs = [ libiconv ]
    ++ dlopenBuildInputs
    ++ optional  ibusSupport ibus
    ++ optional  fcitxSupport fcitx
    ++ optionals stdenv.isDarwin [ AudioUnit Cocoa CoreAudio CoreServices ForceFeedback OpenGL ];

  enableParallelBuilding = true;

  configureFlags = [
    "--disable-oss"
  ] ++ optional (!x11Support) "--without-x"
    ++ optional alsaSupport "--with-alsa-prefix=${alsaLib.out}/lib"
    ++ optional stdenv.isDarwin "--disable-sdltest";

  postInstall = ''
    moveToOutput lib/libSDL2main.a "$dev"
    rm $out/lib/*.a
    moveToOutput bin/sdl2-config "$dev"
  '';

  # SDL is weird in that instead of just dynamically linking with
  # libraries when you `--enable-*` (or when `configure` finds) them
  # it `dlopen`s them at runtime. In principle, this means it can
  # ignore any missing optional dependencies like alsa, pulseaudio,
  # some x11 libs, wayland, etc if they are missing on the system
  # and/or work with wide array of versions of said libraries. In
  # nixpkgs, however, we don't need any of that. Moreover, since we
  # don't have a global ld-cache we have to stuff all the propagated
  # libraries into rpath by hand or else some applications that use
  # SDL API that requires said libraries will fail to start.
  #
  # You can grep SDL sources with `grep -rE 'SDL_(NAME|.*_SYM)'` to
  # list the symbols used in this way.
  postFixup = let
    rpath = makeLibraryPath (dlopenPropagatedBuildInputs ++ dlopenBuildInputs);
  in optionalString (stdenv.hostPlatform.extensions.sharedLibrary == ".so") ''
    for lib in $out/lib/*.so* ; do
      if ! [[ -L "$lib" ]]; then
        patchelf --set-rpath "$(patchelf --print-rpath $lib):${rpath}" "$lib"
      fi
    done
  '';

  setupHook = ./setup-hook.sh;

  passthru = { inherit openglSupport; };

  meta = with stdenv.lib; {
    description = "A cross-platform multimedia library";
    homepage = http://www.libsdl.org/;
    license = licenses.zlib;
    platforms = platforms.all;
    maintainers = with maintainers; [ cpages ];
  };
}
