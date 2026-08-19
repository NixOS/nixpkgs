{ mkDerivation, alex, array, base, binary, bytestring, containers
, deepseq, directory, fetchzip, filepath, lib, mtl, parsec, pretty
, text, time, transformers
}:
mkDerivation {
  pname = "Cabal-syntax";
  version = "3.16.0.0";
  src = fetchzip {
    url = "https://hackage.haskell.org/package/Cabal-syntax-3.16.0.0/Cabal-syntax-3.16.0.0.tar.gz";
    sha256 = "09c987i6mn4j8ib894wfvh397rqxcw0ylid8bgn3xfqpwiwar58j";
  };
  libraryHaskellDepends = [
    array base binary bytestring containers deepseq directory filepath
    mtl parsec pretty text time transformers
  ];
  libraryToolDepends = [ alex ];
  homepage = "http://www.haskell.org/cabal/";
  description = "A library for working with .cabal files";
  license = lib.meta.getLicenseFromSpdxId "BSD-3-Clause";
}
