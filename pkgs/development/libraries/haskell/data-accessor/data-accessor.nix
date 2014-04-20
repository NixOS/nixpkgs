{ cabal, transformers }:

cabal.mkDerivation (self: {
  pname = "data-accessor";
  version = "0.2.2.5";
  sha256 = "0z63fv41cnpk3h404gprk2f5jl7rrpyv97xmsgac9zgdm5zkkhm6";
  buildDepends = [ transformers ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Record_access";
    description = "Utilities for accessing and manipulating fields of records";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
