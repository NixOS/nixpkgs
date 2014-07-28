{ cabal, transformers }:

cabal.mkDerivation (self: {
  pname = "data-accessor";
  version = "0.2.2.6";
  sha256 = "0668qgllmp2911ppsb0g9z95nq2x0h2cvzyyjlb6iwhnjzyyg7gf";
  buildDepends = [ transformers ];
  jailbreak = true;
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Record_access";
    description = "Utilities for accessing and manipulating fields of records";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
