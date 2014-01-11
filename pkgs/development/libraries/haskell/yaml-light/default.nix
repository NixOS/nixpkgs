{ cabal, HsSyck }:

cabal.mkDerivation (self: {
  pname = "yaml-light";
  version = "0.1";
  sha256 = "1p1swas1nhmnkj82msglacgqa5xwg18vya6jirb2a2ywny8r80rx";
  buildDepends = [ HsSyck ];
  meta = {
    description = "A light-weight wrapper with utility functions around HsSyck";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
