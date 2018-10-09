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

let

  # XXX: By default, SDL wants to dlopen() PulseAudio, in which case
  # we must arrange to add it to its RPATH; however, `patchelf' seems
  # to fail at doing this, hence `--disable-pulseaudio-shared'.
  configureFlagsFun = attrs: [
      "--disable-oss" "--disable-x11-shared" "--disable-wayland-shared"
      "--disable-pulseaudio-shared" "--disable-alsa-shared"
    ] ++ optional alsaSupport "--with-alsa-prefix=${attrs.alsaLib.out}/lib"
      ++ optional (!x11Support) "--without-x";

in

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

  # Since `libpulse*.la' contain `-lgdbm', PulseAudio must be propagated.
  propagatedBuildInputs = [ libiconv ]
    ++ optionals x11Support [ libICE libXi libXScrnSaver libXcursor libXinerama libXext libXrandr libXxf86vm ]
    ++ optionals waylandSupport [ wayland wayland-protocols libxkbcommon ]
    ++ optional  pulseaudioSupport libpulseaudio;

  buildInputs = [ audiofile ]
    ++ optional openglSupport libGL
    ++ optional alsaSupport alsaLib
    ++ optional dbusSupport dbus
    ++ optional udevSupport udev
    ++ optional ibusSupport ibus
    ++ optionals stdenv.isDarwin [ AudioUnit Cocoa CoreAudio CoreServices ForceFeedback OpenGL ];

  # https://bugzilla.libsdl.org/show_bug.cgi?id=1431
  dontDisableStatic = true;

  # /build/SDL2-2.0.7/src/video/wayland/SDL_waylandevents.c:41:10: fatal error:
  #   pointer-constraints-unstable-v1-client-protocol.h: No such file or directory
  enableParallelBuilding = false;

  configureFlags = configureFlagsFun { inherit alsaLib; };

  crossAttrs = {
    configureFlags = configureFlagsFun { alsaLib = alsaLib.crossDrv; };
  };

  postInstall = ''
    moveToOutput lib/libSDL2main.a "$dev"
    rm $out/lib/*.a
    moveToOutput bin/sdl2-config "$dev"
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
