{ stdenv, fetchgit, cairo, libjpeg, libXft, pkgconfig, python2 }:

stdenv.mkDerivation rec {
  name = "ntk-${version}";
  version = "2017-04-22";
  src = fetchgit {
    url = "git://git.tuxfamily.org/gitroot/non/fltk.git";
    rev = "92365eca0f9a6f054abc70489c009aba0fcde0ff";
    sha256 = "0pph7hf07xaa011zr40cs62f3f7hclfbv5kcrl757gcp2s5pi2iq";
  };

  buildInputs = [
    cairo libjpeg libXft pkgconfig python2
  ];

  buildPhase = ''
    python waf configure --prefix=$out
    python waf
  '';

  installPhase = ''
    python waf install
  '';

  meta = {
    description = "Fork of FLTK 1.3.0 with additional functionality";
    version = "${version}";
    homepage = http://non.tuxfamily.org/;
    license = stdenv.lib.licenses.lgpl21;
    maintainers = [ stdenv.lib.maintainers.magnetophon ];
    platforms = stdenv.lib.platforms.linux;
  };
}
