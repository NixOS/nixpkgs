{ stdenv, fetchurl, flex, bison, ncurses, buddy, tecla, libsigsegv, gmp, unzip }:

stdenv.mkDerivation rec {
  name = "maude-2.4-alpha-91d";
  meta = {
    homepage = "http://maude.cs.uiuc.edu/";
    description = "Maude -- a high-level specification language";
    license = "GPLv2";
  };
  src = fetchurl {
    url = "http://www.csl.sri.com/users/eker/Maude/Alpha91d/Maude-2.4.tar.gz";
    sha256 = "0bydkf8fd5v267bfak4mm5lmm3vvnr6ir1jr7gimgyzqygdk0in2";
  };
  fullMaude = fetchurl {
    url = "http://www.lcc.uma.es/~duran/FullMaude/FM23l/full-maude.maude.zip";
    sha256 = "08m54dskj2c6x00a5l5x1my88na4x8wmm048g0srsknhv5j91lf2";
  };
  docs = fetchurl {
    url = "http://mirror.switch.ch/mirror/gentoo/distfiles/maude-2.3.0-extras.tar.bz2";
    sha256 = "0kd5623k1wwj1rk4b6halrm3sdvd9kbiwg1hi2c3qim1nlfdgl0d";
  };
  buildInputs = [flex bison unzip ncurses buddy tecla gmp libsigsegv];
  configurePhase = ''./configure --disable-dependency-tracking --prefix=$out TECLA_LIBS="-ltecla -lncursesw" CFLAGS="-O3" CXXFLAGS="-O3"'';
  doCheck = true;
  postInstall =
  ''
    ensureDir $out/share/maude
    cp src/Main/*.maude $out/share/maude/
    unzip -aa ${fullMaude}
    mv full-maude.maude $out/share/maude/full-maude.maude

    ensureDir $out/share/doc/maude
    tar xf ${docs}
    rm -f maude-2.3.0-extras/full-maude.maude
    mv maude-2.3.0-extras/pdfs $out/share/doc/maude/pdf
    mv maude-2.3.0-extras/* $out/share/doc/maude/
  '';
}
