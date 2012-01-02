{ cabal, transformers }:

cabal.mkDerivation (self: {
  pname = "data-accessor";
  version = "0.2.2.1";
  sha256 = "1zb7z9fnlnxxlvjd655vadfscanzq9msvjv21cjmdric0ja24hxb";
  buildDepends = [ transformers ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Record_access";
    description = "Utilities for accessing and manipulating fields of records";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
