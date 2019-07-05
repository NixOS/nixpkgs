{stdenv, fetchurl, autoconf, automake, libtool, fetchpatch}:

stdenv.mkDerivation rec {
  pName = "soundtouch";
  name = "${pName}-2.0.0";
  src = fetchurl {
    url = "https://www.surina.net/soundtouch/${name}.tar.gz";
    sha256 = "09cxr02mfyj2bg731bj0i9hh565x8l9p91aclxs8wpqv8b8zf96j";
  };

  patches = [
    (fetchpatch {
      url = "https://gitlab.com/soundtouch/soundtouch/commit/9e02d9b04fda6c1f44336ff00bb5af1e2ffc039e.patch";
      name = "CVE-2018-1000223.patch";
      sha256 = "1ji8xrc3qyp9jdycrdv9bwpfpgw63nnd7xwl32sjwbf8v80xpdkp";
    })
  ];

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
