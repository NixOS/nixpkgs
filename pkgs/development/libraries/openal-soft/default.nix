{ stdenv, fetchurl, cmake, alsaLib }:

stdenv.mkDerivation rec {
#The current release is still in a testing phase, though it should be stable
# (neither the ABI or API will break). Please try it out and let me know how it
#  works. :-)

  version = "1.15.1";
  name = "openal-soft-${version}";

  src = fetchurl {
    url = "http://kcat.strangesoft.net/openal-releases/${name}.tar.bz2";
    sha256 = "0mmhdqiyb3c9dzvxspm8h2v8jibhi8pfjxnf6m0wn744y1ia2a8f";
  };

  buildInputs = [ cmake alsaLib ];
  
  meta = {
    description = "OpenAL alternative";
    homepage = http://kcat.strangesoft.net/openal.html;
    license = "GPL2";
  };
}
