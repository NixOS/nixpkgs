{ stdenv, fetchurl, alsaLib, pkgconfig }:

stdenv.mkDerivation rec {
  name = "portaudio-19-20071207";
	
  src = fetchurl {
    url = http://www.portaudio.com/archives/pa_stable_v19_20071207.tar.gz;
    sha256 = "0axz8xzkb6ynzj65p6cv6b0cl5csxsdfvqkd0dljlf3dslkpg886";
  };

  buildInputs = [ alsaLib pkgconfig ];
  
  meta = {
    description = "Portable cross-platform Audio API";
    homepage = http://www.portaudio.com/;
    # Not exactly a bsd license, but alike
    license = "BSD";
  };

  passthru = {
    api_version = 19;
  };
}
