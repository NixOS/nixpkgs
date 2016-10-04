{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "poker-eval-138.0";

  src = fetchurl {
    url = "http://download.gna.org/pokersource/sources/${name}.tar.gz";
    sha256 = "0s6gvcdwdi6j7nrg6mmb5l971gclk0p99bcbfsynx1gnj159wrcj";
  };

  patchPhase = ''
    sed -i -e 's#pkgincludedir = $(includedir)/@PACKAGE@#pkgincludedir = $(includedir)#g' Makefile.in
    sed -i -e 's#pkgincludedir = $(includedir)/@PACKAGE@#pkgincludedir = $(includedir)#g' include/Makefile.in
    sed -i -e 's#includedir=@includedir@/poker-eval#includedir=@includedir@/#g' poker-eval.pc.in
  '';

  meta = {
    homepage = http://pokersource.org/poker-eval/;
    description = "Poker hand evaluator";
    license = stdenv.lib.licenses.gpl3;
    maintainers = [stdenv.lib.maintainers.mtreskin];
    platforms = stdenv.lib.platforms.all;
  };
}
