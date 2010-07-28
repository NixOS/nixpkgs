{ stdenv, fetchurl, cmake, alsaLib }:

stdenv.mkDerivation {
#The current release is still in a testing phase, though it should be stable
# (neither the ABI or API will break). Please try it out and let me know how it
#  works. :-)

  name = "openal-soft-1.1.93";

  src = fetchurl {
    url = http://kcat.strangesoft.net/openal-releases/openal-soft-1.1.93.tar.bz2;
    sha256 = "162nyv4jy6qzi7s5q3wpdawfph6npyn1n4wjf21haxdxq0mmp6l7";
  };

  buildInputs = [ cmake alsaLib ];
  
  meta = {
    description = "OpenAL alternative";
    homepage = http://kcat.strangesoft.net/openal.html;
    license = "GPL2";
  };
}
