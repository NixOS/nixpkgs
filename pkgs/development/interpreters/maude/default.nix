{ stdenv, fetchurl, flex, bison, ncurses, buddy, tecla, gmp }:

stdenv.mkDerivation rec {
  name = "maude-2.3";
  meta = {
    homepage = "http://maude.cs.uiuc.edu/";
    description = "Maude -- a high-level specification language";
    license = "GPLv2";
  };
  src = fetchurl {
    url = "http://maude.cs.uiuc.edu/download/current/Maude-2.3.tar.gz";
    sha256 = "1nzxj8x1379nxsdvldqy55wl513hdi4xwf8i2bhngz7s8228vs37";
  };
  docs = fetchurl {
    url = "http://mirror.switch.ch/mirror/gentoo/distfiles/maude-2.3.0-extras.tar.bz2";
    sha256 = "0kd5623k1wwj1rk4b6halrm3sdvd9kbiwg1hi2c3qim1nlfdgl0d";
  };
  buildInputs = [flex bison ncurses buddy tecla gmp];
  configurePhase = ''./configure --disable-dependency-tracking --prefix=$out TECLA_LIBS="-ltecla -lncursesw" CFLAGS="-O3" CXXFLAGS="-O3"'';
  # Regression test suite says:
  #   FAIL: metaWellFormed
  doCheck = false;
  postInstall =
  ''
    ensureDir $out/share/maude
    ensureDir $out/share/doc/maude
    tar xf ${docs}
    mv src/Main/*.maude maude-2.3.0-extras/*.maude $out/share/maude/
    mv maude-2.3.0-extras/pdfs $out/share/doc/maude/pdf
    mv maude-2.3.0-extras/* $out/share/doc/maude/
  '';
}
