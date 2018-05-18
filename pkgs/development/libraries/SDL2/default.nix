{ stdenv, lib, fetchurl, pkgconfig, audiofile
, openglSupport ? false, libGL
, alsaSupport ? true, alsaLib
, x11Support ? true, libICE, libXi, libXScrnSaver, libXcursor, libXinerama, libXext, libXxf86vm, libXrandr
, waylandSupport ? true, wayland, wayland-protocols, libxkbcommon
, dbusSupport ? false, dbus
, udevSupport ? false, udev
, ibusSupport ? false, ibus
, pulseaudioSupport ? true, libpulseaudio
, AudioUnit, Cocoa, CoreAudio, CoreServices, ForceFeedback, OpenGL
, libiconv
}:

# NOTE: When editing this expression see if the same change applies to
# SDL expression too

with lib;

assert !stdenv.isDarwin -> alsaSupport || pulseaudioSupport;
assert openglSupport -> (stdenv.isDarwin || x11Support && libGL != null);

stdenv.mkDerivation rec {
  name = "SDL2-${version}";
  version = "2.0.8";

  src = fetchurl {
    url = "http://www.libsdl.org/release/${name}.tar.gz";
    sha256 = "1v4js1gkr75hzbxzhwzzif0sf9g07234sd23x1vdaqc661bprizd";
  };

  outputs = [ "out" "dev" ];
  outputBin = "dev"; # sdl-config

  patches = [ ./find-headers.patch ];

  nativeBuildInputs = [ pkgconfig ];

  propagatedBuildInputs = [ libiconv ]
    ++ optional  dbusSupport dbus
    ++ optional  udevSupport udev
    ++ optionals x11Support [ libICE libXi libXScrnSaver libXcursor libXinerama libXext libXrandr libXxf86vm ]
    ++ optionals waylandSupport [ wayland wayland-protocols libxkbcommon ]
    ++ optional  alsaSupport alsaLib
    ++ optional  pulseaudioSupport libpulseaudio;

  buildInputs = [ audiofile ]
    ++ optional  openglSupport libGL
    ++ optional  ibusSupport ibus
    ++ optionals stdenv.isDarwin [ AudioUnit Cocoa CoreAudio CoreServices ForceFeedback OpenGL ];

  # /build/SDL2-2.0.7/src/video/wayland/SDL_waylandevents.c:41:10: fatal error:
  #   pointer-constraints-unstable-v1-client-protocol.h: No such file or directory
  enableParallelBuilding = false;

  configureFlags = [
    "--disable-oss"
  ] ++ optional (!x11Support) "--without-x"
    ++ optional alsaSupport "--with-alsa-prefix=${alsaLib.out}/lib";

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
  # confirm that they actually use most of the `propagatedBuildInputs`
  # from above in this way. This is pretty weird.
  postFixup = ''
    for lib in $out/lib/*.so* ; do
      if [[ -L "$lib" ]]; then
        patchelf --set-rpath "$(patchelf --print-rpath $lib):${lib.makeLibraryPath propagatedBuildInputs}" "$lib"
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
