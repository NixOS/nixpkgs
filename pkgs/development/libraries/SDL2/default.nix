{ stdenv, config, libGLSupported, fetchurl, pkgconfig
, openglSupport ? libGLSupported, libGL
, alsaSupport ? stdenv.isLinux, alsaLib
, x11Support ? !stdenv.isCygwin, libX11, xorgproto, libICE, libXi, libXScrnSaver, libXcursor, libXinerama, libXext, libXxf86vm, libXrandr
, waylandSupport ? stdenv.isLinux, wayland, wayland-protocols, libxkbcommon
, dbusSupport ? stdenv.isLinux, dbus
, udevSupport ? false, udev
, ibusSupport ? false, ibus
, pulseaudioSupport ? config.pulseaudio or stdenv.isLinux, libpulseaudio
, AudioUnit, Cocoa, CoreAudio, CoreServices, ForceFeedback, OpenGL
, audiofile, cf-private, libiconv
}:

# NOTE: When editing this expression see if the same change applies to
# SDL expression too

with stdenv.lib;

assert !stdenv.isDarwin -> alsaSupport || pulseaudioSupport;
assert openglSupport -> (stdenv.isDarwin || x11Support && libGL != null);

stdenv.mkDerivation rec {
  name = "SDL2-${version}";
  version = "2.0.9";

  src = fetchurl {
    url = "https://www.libsdl.org/release/${name}.tar.gz";
    sha256 = "1c94ndagzkdfqaa838yqg589p1nnqln8mv0hpwfhrkbfczf8cl95";
  };

  outputs = [ "out" "dev" ];
  outputBin = "dev"; # sdl-config

  patches = [ ./find-headers.patch ];

  nativeBuildInputs = [ pkgconfig ];

  propagatedBuildInputs = dlopenPropagatedBuildInputs;

  dlopenPropagatedBuildInputs = [ ]
    # Propagated for #include <GLES/gl.h> in SDL_opengles.h.
    ++ optional openglSupport libGL
    # Propagated for #include <X11/Xlib.h> and <X11/Xatom.h> in SDL_syswm.h.
    ++ optionals x11Support [ libX11 xorgproto ];

  dlopenBuildInputs = [ ]
    ++ optional  alsaSupport alsaLib
    ++ optional  dbusSupport dbus
    ++ optional  pulseaudioSupport libpulseaudio
    ++ optional  udevSupport udev
    ++ optionals waylandSupport [ wayland wayland-protocols libxkbcommon ]
    ++ optionals x11Support [ libICE libXi libXScrnSaver libXcursor libXinerama libXext libXrandr libXxf86vm ];

  buildInputs = [ audiofile libiconv ]
    ++ dlopenBuildInputs
    ++ optional  ibusSupport ibus
    ++ optionals stdenv.isDarwin [
      AudioUnit Cocoa CoreAudio CoreServices ForceFeedback OpenGL
      # Needed for NSDefaultRunLoopMode symbols.
      cf-private
    ];

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
