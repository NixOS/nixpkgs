{ lib
, stdenv
, config
, fetchurl
, pkg-config
, libGLSupported ? lib.elem stdenv.hostPlatform.system lib.platforms.mesaPlatforms
, openglSupport ? libGLSupported
, libGL
, alsaSupport ? stdenv.isLinux && !stdenv.hostPlatform.isAndroid
, alsa-lib
, x11Support ? !stdenv.targetPlatform.isWindows && !stdenv.hostPlatform.isAndroid
, libX11
, xorgproto
, libICE
, libXi
, libXScrnSaver
, libXcursor
, libXinerama
, libXext
, libXxf86vm
, libXrandr
, waylandSupport ? stdenv.isLinux && !stdenv.hostPlatform.isAndroid
, wayland
, wayland-protocols
, wayland-scanner
, drmSupport ? stdenv.isLinux && !stdenv.hostPlatform.isAndroid
, libdrm
, mesa
, libxkbcommon
, dbusSupport ? stdenv.isLinux && !stdenv.hostPlatform.isAndroid
, dbus
, udevSupport ? stdenv.isLinux && !stdenv.hostPlatform.isAndroid
, udev
, ibusSupport ? false
, ibus
, fcitxSupport ? false
, fcitx
, libdecorSupport ? stdenv.isLinux && !stdenv.hostPlatform.isAndroid
, libdecor
, pipewireSupport ? stdenv.isLinux && !stdenv.hostPlatform.isAndroid
, pipewire # NOTE: must be built with SDL2 without pipewire support
, pulseaudioSupport ? config.pulseaudio or stdenv.isLinux && !stdenv.hostPlatform.isAndroid
, libpulseaudio
, AudioUnit
, Cocoa
, CoreAudio
, CoreServices
, ForceFeedback
, OpenGL
, audiofile
, libiconv
, withStatic ? false
}:

# NOTE: When editing this expression see if the same change applies to
# SDL expression too

with lib;

stdenv.mkDerivation rec {
  pname = "SDL2";
  version = "2.0.22";

  src = fetchurl {
    url = "https://www.libsdl.org/release/${pname}-${version}.tar.gz";
    sha256 = "sha256-/ny/MSeILj/HJZp1oMtYViAnLFF0XThSq53YeWBpfy4=";
  };
  dontDisableStatic = withStatic;
  outputs = [ "out" "dev" ];
  outputBin = "dev"; # sdl-config

  patches = [
    # `sdl2-config --cflags` from Nixpkgs returns include path to just SDL2.
    # On a normal distro this is enough for includes from all SDL2* packages to work,
    # but on NixOS they're spread across different paths.
    # This patch + the setup-hook will ensure that `sdl2-config --cflags` works correctly.
    ./find-headers.patch
  ];

  postPatch = ''
    # Fix running wayland-scanner for the build platform when cross-compiling.
    # See comment here: https://github.com/libsdl-org/SDL/issues/4860#issuecomment-1119003545
    substituteInPlace configure \
      --replace '$(WAYLAND_SCANNER)' 'wayland-scanner'
  '';

  strictDeps = true;

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [ pkg-config ] ++ optionals waylandSupport [ wayland wayland-scanner ];

  propagatedBuildInputs = dlopenPropagatedBuildInputs;

  dlopenPropagatedBuildInputs = [ ]
    # Propagated for #include <GLES/gl.h> in SDL_opengles.h.
    ++ optional openglSupport libGL
    # Propagated for #include <X11/Xlib.h> and <X11/Xatom.h> in SDL_syswm.h.
    ++ optionals x11Support [ libX11 xorgproto ];

  dlopenBuildInputs = optionals alsaSupport [ alsa-lib audiofile ]
    ++ optional dbusSupport dbus
    ++ optional libdecorSupport libdecor
    ++ optional pipewireSupport pipewire
    ++ optional pulseaudioSupport libpulseaudio
    ++ optional udevSupport udev
    ++ optionals waylandSupport [ wayland wayland-protocols libxkbcommon ]
    ++ optionals x11Support [ libICE libXi libXScrnSaver libXcursor libXinerama libXext libXrandr libXxf86vm ]
    ++ optionals drmSupport [ libdrm mesa ];

  buildInputs = [ libiconv ]
    ++ dlopenBuildInputs
    ++ optional ibusSupport ibus
    ++ optional fcitxSupport fcitx
    ++ optionals stdenv.isDarwin [ AudioUnit Cocoa CoreAudio CoreServices ForceFeedback OpenGL ];

  enableParallelBuilding = true;

  configureFlags = [
    "--disable-oss"
  ] ++ optional (!x11Support) "--without-x"
  ++ optional alsaSupport "--with-alsa-prefix=${alsa-lib.out}/lib"
  ++ optional stdenv.targetPlatform.isWindows "--disable-video-opengles"
  ++ optional stdenv.isDarwin "--disable-sdltest";

  # We remove libtool .la files when static libs are requested,
  # because they make the builds of downstream libs like `SDL_tff`
  # fail with `cannot find -lXext, `-lXcursor` etc. linker errors
  # because the `.la` files are not pruned if static libs exist
  # (see https://github.com/NixOS/nixpkgs/commit/fd97db43bcb05e37f6bb77f363f1e1e239d9de53)
  # and they also don't carry the necessary `-L` paths of their
  # X11 dependencies.
  # For static linking, it is better to rely on `pkg-config` `.pc`
  # files.
  postInstall = ''
    if [ "$dontDisableStatic" -eq "1" ]; then
      rm $out/lib/*.la
    else
      rm $out/lib/*.a
    fi
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
  postFixup =
    let
      rpath = makeLibraryPath (dlopenPropagatedBuildInputs ++ dlopenBuildInputs);
    in
    optionalString (stdenv.hostPlatform.extensions.sharedLibrary == ".so") ''
      for lib in $out/lib/*.so* ; do
        if ! [[ -L "$lib" ]]; then
          patchelf --set-rpath "$(patchelf --print-rpath $lib):${rpath}" "$lib"
        fi
      done
    '';

  setupHook = ./setup-hook.sh;

  passthru = { inherit openglSupport; };

  meta = with lib; {
    description = "A cross-platform multimedia library";
    homepage = "http://www.libsdl.org/";
    license = licenses.zlib;
    platforms = platforms.all;
    maintainers = with maintainers; [ cpages ];
  };
}
