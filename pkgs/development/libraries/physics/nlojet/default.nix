{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "nlojet++";
  version = "4.1.3";

  src = fetchurl {
    url = "https://desy.de/~znagy/hep-programs/nlojet++/nlojet++-${version}.tar.gz";
    sha256 = "18qfn5kjzvnyh29x40zm2maqzfmrnay9r58n8pfpq5lcphdhhv8p";
  };

  patches = [
    ./nlojet_clang_fix.patch
  ];

  env.CXXFLAGS="-std=c++11";

  # error: no member named 'finite' in the global namespace; did you mean simply 'finite'?
  env.NIX_CFLAGS_COMPILE = lib.optionalString (stdenv.isDarwin && stdenv.isAarch64) "-Dfinite=isfinite";

  meta = {
    homepage    = "http://www.desy.de/~znagy/Site/NLOJet++.html";
    license     = lib.licenses.gpl2;
    description = "Implementation of calculation of the hadron jet cross sections";
    platforms   = lib.platforms.unix;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
