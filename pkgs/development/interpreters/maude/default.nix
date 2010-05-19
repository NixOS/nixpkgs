{ stdenv, fetchurl, flex, bison, ncurses, buddy, tecla, libsigsegv, gmpxx, makeWrapper }:

stdenv.mkDerivation rec {
  name = "maude-2.4";

  src = fetchurl {
    url = "http://maude.cs.uiuc.edu/download/current/Maude-2.4.tar.gz";
    sha256 = "0bydkf8fd5v267bfak4mm5lmm3vvnr6ir1jr7gimgyzqygdk0in2";
  };

  fullMaude = fetchurl {
    url = "http://maude.cs.uiuc.edu/download/current/FM2.4/full-maude24.maude";
    sha256 = "9e4ebdc717dc968d0b6c1179f360e60b3a39ea8cecc1a7fa49f2105bbddc48c4";
  };

  docs = fetchurl {
    url = "http://mirror.switch.ch/mirror/gentoo/distfiles/maude-2.3.0-extras.tar.bz2";
    sha256 = "0kd5623k1wwj1rk4b6halrm3sdvd9kbiwg1hi2c3qim1nlfdgl0d";
  };

  buildInputs = [flex bison ncurses buddy tecla gmpxx libsigsegv makeWrapper];

  configurePhase = ''./configure --disable-dependency-tracking --prefix=$out --datadir=$out/share/maude TECLA_LIBS="-ltecla -lncursesw" CFLAGS="-O3" CXXFLAGS="-O3"'';

  doCheck = true;

  postInstall =
  ''
    for n in $out/bin/*; do wrapProgram "$n" --suffix MAUDE_LIB ':' "$out/share/maude"; done
    ensureDir $out/share/maude
    cp ${fullMaude} $out/share/maude/full-maude.maude

    ensureDir $out/share/doc/maude
    tar xf ${docs}
    rm -f maude-2.3.0-extras/full-maude.maude
    mv maude-2.3.0-extras/pdfs $out/share/doc/maude/pdf
    mv maude-2.3.0-extras/* $out/share/doc/maude/
  '';

  meta = {
    homepage = "http://maude.cs.uiuc.edu/";
    description = "Maude -- a high-level specification language";
    license = "GPLv2";
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
