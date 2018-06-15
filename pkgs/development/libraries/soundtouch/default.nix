{stdenv, fetchurl, autoconf, automake, libtool}:

stdenv.mkDerivation rec {
  pName = "soundtouch";
  name = "${pName}-2.0.0";
  src = fetchurl {
    url = "http://www.surina.net/soundtouch/${name}.tar.gz";
    sha256 = "09cxr02mfyj2bg731bj0i9hh565x8l9p91aclxs8wpqv8b8zf96j";
  };

  buildInputs = [ autoconf automake libtool ];

  preConfigure = "./bootstrap";

  meta = {
      description = "A program and library for changing the tempo, pitch and playback rate of audio";
      homepage = http://www.surina.net/soundtouch/;
      downloadPage = http://www.surina.net/soundtouch/sourcecode.html;
      license = stdenv.lib.licenses.lgpl21;
      platforms = stdenv.lib.platforms.all;
  };
}
