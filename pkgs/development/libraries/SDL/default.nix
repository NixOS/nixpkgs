{ stdenv, fetchurl, x11, libXrandr, pkgconfig
, openglSupport ? false, mesa ? null
, alsaSupport ? true, alsaLib ? null
, pulseaudioSupport ? true, pulseaudio ? null
}:

# OSS is no longer supported, for it's much crappier than ALSA and
# PulseAudio.
assert alsaSupport || pulseaudioSupport;

assert openglSupport -> mesa != null;
assert alsaSupport -> alsaLib != null;
assert pulseaudioSupport -> pulseaudio != null;

stdenv.mkDerivation rec {
  name = "SDL-1.2.14";

  src = fetchurl {
    url = "http://www.libsdl.org/release/${name}.tar.gz";
    sha256 = "1dnrxr18cyar0xd13dca7h8wp1fin4n3iyncxfq6pjrlf0l7x4jx";
  };

  # Since `libpulse*.la' contain `-lgdbm', PulseAudio must be propagated.
  propagatedBuildInputs = [ x11 libXrandr ] ++
    stdenv.lib.optional pulseaudioSupport pulseaudio;

  buildInputs = [ pkgconfig ] ++
    stdenv.lib.optional openglSupport mesa ++
    stdenv.lib.optional alsaSupport alsaLib;

  # XXX: By default, SDL wants to dlopen() PulseAudio, in which case
  # we must arrange to add it to its RPATH; however, `patchelf' seems
  # to fail at doing this, hence `--disable-pulseaudio-shared'.
  configureFlags = ''
    --disable-oss
    --disable-x11-shared --disable-alsa-shared --enable-rpath --disable-pulseaudio-shared
    ${if alsaSupport then "--with-alsa-prefix=${alsaLib}/lib" else ""}
  '';

  passthru = {inherit openglSupport;};

  meta = {
    description = "A cross-platform multimedia library";
    homepage = http://www.libsdl.org/;
  };
}
