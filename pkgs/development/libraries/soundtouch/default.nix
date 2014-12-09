{stdenv, fetchurl, autoconf, automake, libtool}:

stdenv.mkDerivation rec {
  pName = "soundtouch";
  name = "${pName}-1.8.0";
  src = fetchurl {
    url = "http://www.surina.net/soundtouch/${name}.tar.gz";
    sha256 = "3d4161d74ca25c5a98c69dbb8ea10fd2be409ba1a3a0bf81db407c4c261f166b";
  };

  buildInputs = [ autoconf automake libtool ];

  preConfigurePhases = "./bootstrap";

  meta = {
      description = "A program and library for changing the tempo, pitch and playback rate of audio";
      homepage = http://www.surina.net/soundtouch/;
      downloadPage = http://www.surina.net/soundtouch/sourcecode.html;
      license = stdenv.lib.licenses.lgpl21;
      platforms = stdenv.lib.platforms.all;
  };
}
