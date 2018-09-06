{ mkDerivation, base, Cabal, containers, directory, extra, filepath
, mtl, parsec, pretty, stdenv, time, transformers
}:
mkDerivation {
  pname = "curry-base";
  version = "1.0.0";
  src = ./.;
  libraryHaskellDepends = [
    base containers directory extra filepath mtl parsec pretty time
    transformers
  ];
  testHaskellDepends = [ base Cabal filepath mtl ];
  homepage = "http://curry-language.org";
  description = "Functions for manipulating Curry programs";
  license = stdenv.lib.licenses.bsd3;
}
