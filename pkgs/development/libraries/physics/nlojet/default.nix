{ stdenv, fetchurl, fetchpatch }:

stdenv.mkDerivation rec {
  name = "nlojet++-${version}";
  version = "4.1.3";

  src = fetchurl {
    url = "http://desy.de/~znagy/hep-programs/nlojet++/nlojet++-${version}.tar.gz";
    sha256 = "18qfn5kjzvnyh29x40zm2maqzfmrnay9r58n8pfpq5lcphdhhv8p";
  };

  patches = [
    ./nlojet_clang_fix.patch
  ];

  meta = {
    homepage    = "http://www.desy.de/~znagy/Site/NLOJet++.html";
    license     = stdenv.lib.licenses.gpl2;
    description = "Implementation of calculation of the hadron jet cross sections";
    platforms   = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ veprbl ];
  };
}
