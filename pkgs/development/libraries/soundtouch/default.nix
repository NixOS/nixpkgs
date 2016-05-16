{stdenv, fetchurl, autoconf, automake, libtool}:

stdenv.mkDerivation rec {
  pName = "soundtouch";
  name = "${pName}-1.9.2";
  src = fetchurl {
    url = "http://www.surina.net/soundtouch/${name}.tar.gz";
    sha256 = "04y5l56yn4jvwpv9mn1p3m2vi5kdym9xpdac8pmhwhl13r8qdsya";
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
