{ stdenv, fetchurl, pkgconfig, audiofile
, openglSupport ? false, mesa ? null
, alsaSupport ? true, alsaLib ? null
, x11Support ? true, x11 ? null, libXrandr ? null
, pulseaudioSupport ? true, pulseaudio ? null
}:

# OSS is no longer supported, for it's much crappier than ALSA and
# PulseAudio.
assert alsaSupport || pulseaudioSupport;

assert openglSupport -> (mesa != null && x11Support);
assert x11Support -> (x11 != null && libXrandr != null);
assert alsaSupport -> alsaLib != null;
assert pulseaudioSupport -> pulseaudio != null;

let
  configureFlagsFun = attrs: ''
        --disable-oss --disable-x11-shared
        --disable-pulseaudio-shared --disable-alsa-shared
        ${if alsaSupport then "--with-alsa-prefix=${attrs.alsaLib}/lib" else ""}
      '';
in
stdenv.mkDerivation rec {
  name = "SDL2-2.0.2";

  src = fetchurl {
    url = "http://www.libsdl.org/release/${name}.tar.gz";
    sha256 = "0l78h3wlirnxxrdw3kkm9amhgjn6xrs9l5j871r552wabbw5f0ar";
  };

  # Since `libpulse*.la' contain `-lgdbm', PulseAudio must be propagated.
  propagatedBuildInputs = stdenv.lib.optionals x11Support [ x11 libXrandr ] ++
    stdenv.lib.optional pulseaudioSupport pulseaudio;

  buildInputs = [ pkgconfig audiofile ] ++
    stdenv.lib.optional openglSupport [ mesa ] ++
    stdenv.lib.optional alsaSupport alsaLib;

  # https://bugzilla.libsdl.org/show_bug.cgi?id=1431
  dontDisableStatic = true;

  # XXX: By default, SDL wants to dlopen() PulseAudio, in which case
  # we must arrange to add it to its RPATH; however, `patchelf' seems
  # to fail at doing this, hence `--disable-pulseaudio-shared'.
  configureFlags = configureFlagsFun { inherit alsaLib; };

  crossAttrs = {
      configureFlags = configureFlagsFun { alsaLib = alsaLib.crossDrv; };
  };

  postInstall = ''
    rm $out/lib/*.a
  '';

  passthru = {inherit openglSupport;};

  meta = {
    description = "A cross-platform multimedia library";
    homepage = http://www.libsdl.org/;
    license = stdenv.lib.licenses.zlib;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.page ];
  };
}
