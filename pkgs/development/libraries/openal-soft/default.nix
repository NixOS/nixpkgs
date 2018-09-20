{ stdenv, fetchurl, cmake
, alsaSupport ? !stdenv.isDarwin, alsaLib ? null
, pulseSupport ? !stdenv.isDarwin, libpulseaudio ? null
, CoreServices, AudioUnit, AudioToolbox
}:

with stdenv.lib;

assert alsaSupport -> alsaLib != null;
assert pulseSupport -> libpulseaudio != null;

stdenv.mkDerivation rec {
  version = "1.19.0";
  name = "openal-soft-${version}";

  src = fetchurl {
    url = "http://kcat.strangesoft.net/openal-releases/${name}.tar.bz2";
    sha256 = "1mhf5bsb58s1xk6hvxl7ly7rd4rpl9z8h07xl1q94brywykg7bgi";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = []
    ++ optional alsaSupport alsaLib
    ++ optional pulseSupport libpulseaudio
    ++ optionals stdenv.isDarwin [ CoreServices AudioUnit AudioToolbox ];

  NIX_LDFLAGS = []
    ++ optional alsaSupport "-lasound"
    ++ optional pulseSupport "-lpulse";

  meta = {
    description = "OpenAL alternative";
    homepage = http://kcat.strangesoft.net/openal.html;
    license = licenses.lgpl2;
    maintainers = with maintainers; [ftrvxmtrx];
    platforms = platforms.unix;
  };
}
