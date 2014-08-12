{ stdenv, fetchurl, cmake
, alsaSupport ? true, alsaLib ? null
, pulseSupport ? true, pulseaudio ? null
}:

assert alsaSupport -> alsaLib != null;
assert pulseSupport -> pulseaudio != null;

stdenv.mkDerivation rec {
  version = "1.15.1";
  name = "openal-soft-${version}";

  src = fetchurl {
    url = "http://kcat.strangesoft.net/openal-releases/${name}.tar.bz2";
    sha256 = "0mmhdqiyb3c9dzvxspm8h2v8jibhi8pfjxnf6m0wn744y1ia2a8f";
  };

  buildInputs = [ cmake ]
    ++ stdenv.lib.optional alsaSupport alsaLib
    ++ stdenv.lib.optional pulseSupport pulseaudio;

  NIX_LDFLAGS = []
    ++ stdenv.lib.optional alsaSupport "-lasound"
    ++ stdenv.lib.optional pulseSupport "-lpulse";

  meta = {
    description = "OpenAL alternative";
    homepage = http://kcat.strangesoft.net/openal.html;
    license = stdenv.lib.licenses.gpl2;
  };
}
