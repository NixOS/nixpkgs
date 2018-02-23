{ config, stdenv, fetchurl, cmake
, alsaSupport ? !stdenv.isDarwin, alsaLib ? null
, pulseaudioSupport ? config.pulseaudio or stdenv.isLinux, libpulseaudio ? null
, CoreServices, AudioUnit, AudioToolbox
}:

with stdenv.lib;

assert alsaSupport -> alsaLib != null;
assert pulseaudioSupport -> libpulseaudio != null;

stdenv.mkDerivation rec {
  version = "1.18.2";
  name = "openal-soft-${version}";

  src = fetchurl {
    url = "http://kcat.strangesoft.net/openal-releases/${name}.tar.bz2";
    sha256 = "10kydm8701a2kppiss9sdidn1820cmzhqgx1b2bsa5dsgzic32lz";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = []
    ++ optional alsaSupport alsaLib
    ++ optional pulseaudioSupport libpulseaudio
    ++ optionals stdenv.isDarwin [ CoreServices AudioUnit AudioToolbox ];

  NIX_LDFLAGS = []
    ++ optional alsaSupport "-lasound"
    ++ optional pulseaudioSupport "-lpulse";

  meta = {
    description = "OpenAL alternative";
    homepage = http://kcat.strangesoft.net/openal.html;
    license = licenses.lgpl2;
    maintainers = with maintainers; [ftrvxmtrx];
    platforms = platforms.unix;
  };
}
