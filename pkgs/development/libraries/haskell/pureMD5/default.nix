{ cabal, binary, cereal, cryptoApi, tagged }:

cabal.mkDerivation (self: {
  pname = "pureMD5";
  version = "2.1.0.3";
  sha256 = "0whlsb6zq4zcp3wq0bd6pgcsl0namr8b2s6i4l5aykq8v7fx40ii";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ binary cereal cryptoApi tagged ];
  meta = {
    description = "A Haskell-only implementation of the MD5 digest (hash) algorithm";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
