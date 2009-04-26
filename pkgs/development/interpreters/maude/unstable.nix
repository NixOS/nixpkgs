{ stdenv, fetchurl, flex, bison, ncurses, buddy, tecla, libsigsegv, gmp }:

stdenv.mkDerivation rec {
  name = "maude-2.4-alpha-91c";
  meta = {
    homepage = "http://maude.cs.uiuc.edu/";
    description = "Maude -- a high-level specification language";
    license = "GPLv2";
  };
  src = fetchurl {
    url = "http://www.csl.sri.com/users/eker/Maude/Alpha91c/Maude-2.4.tar.gz";
    sha256 = "0z25rrmg1b317xba2aqir5719js2ig3k20n1pvq3qvlzg51b6wp1";
  };
  fullMaude = fetchurl {
    url = "http://www.lcc.uma.es/~duran/FullMaude/FM23j/full-maude.maude";
    sha256 = "1x25ckfh1dzn8pg5spzj7f23bkz0favybnaxww8qs29r3lsrl1ib";
  };
  docs = fetchurl {
    url = "http://mirror.switch.ch/mirror/gentoo/distfiles/maude-2.3.0-extras.tar.bz2";
    sha256 = "0kd5623k1wwj1rk4b6halrm3sdvd9kbiwg1hi2c3qim1nlfdgl0d";
  };
  buildInputs = [flex bison ncurses buddy tecla gmp libsigsegv];
  configurePhase = ''./configure --disable-dependency-tracking --prefix=$out TECLA_LIBS="-ltecla -lncursesw" CFLAGS="-O3" CXXFLAGS="-O3"'';
  doCheck = true;
  postInstall =
  ''
    ensureDir $out/share/maude
    cp src/Main/*.maude $out/share/maude/
    cp ${fullMaude} $out/share/maude/full-maude.maude

    ensureDir $out/share/doc/maude
    tar xf ${docs}
    rm -f maude-2.3.0-extras/full-maude.maude
    mv maude-2.3.0-extras/pdfs $out/share/doc/maude/pdf
    mv maude-2.3.0-extras/* $out/share/doc/maude/
  '';
}
