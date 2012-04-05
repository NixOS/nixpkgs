{ stdenv, fetchurl, alsaLib, pkgconfig }:

stdenv.mkDerivation rec {
  name = "portaudio-19-20111121";
  
  src = fetchurl {
    url = http://www.portaudio.com/archives/pa_stable_v19_20111121.tgz;
    sha256 = "168vmcag3c5y3zwf7h5298ydh83g72q5bznskrw9cr2h1lrx29lw";
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
