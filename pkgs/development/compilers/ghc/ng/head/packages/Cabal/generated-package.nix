{ mkDerivation, array, base, bytestring, Cabal-syntax, containers
, deepseq, directory, fetchzip, filepath, lib, mtl, parsec, pretty
, process, time, transformers, unix
}:
mkDerivation {
  pname = "Cabal";
  version = "3.16.0.0";
  src = fetchzip {
    url = "https://hackage.haskell.org/package/Cabal-3.16.0.0/Cabal-3.16.0.0.tar.gz";
    sha256 = "1pr9k8hi27qd9cliwn2fa0kg0v9b61bblba9m7la2prbxibzb8z9";
  };
  setupHaskellDepends = [ mtl parsec ];
  libraryHaskellDepends = [
    array base bytestring Cabal-syntax containers deepseq directory
    filepath mtl parsec pretty process time transformers unix
  ];
  doCheck = false;
  homepage = "http://www.haskell.org/cabal/";
  description = "A framework for packaging Haskell software";
  license = lib.meta.getLicenseFromSpdxId "BSD-3-Clause";
}
