{ mkDerivation, base, fetchzip, ghc-prim, lib }:
mkDerivation {
  pname = "deepseq";
  version = "1.5.1.0";
  src = fetchzip {
    url = "https://hackage.haskell.org/package/deepseq-1.5.1.0/deepseq-1.5.1.0.tar.gz";
    sha256 = "0arfdia1nvjz0n5nczy1dsa042rmb0nwws26qr9q70jgh3w822a5";
  };
  libraryHaskellDepends = [ base ghc-prim ];
  testHaskellDepends = [ base ghc-prim ];
  description = "Deep evaluation of data structures";
  license = lib.licenses.bsd3;
}
