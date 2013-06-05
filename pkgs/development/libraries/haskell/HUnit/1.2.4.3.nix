{ cabal, deepseq }:

cabal.mkDerivation (self: {
  pname = "HUnit";
  version = "1.2.4.3";
  sha256 = "0sk2s0g28wly64nisgrj4wr914zx940pvj5zvkv9n467vssywzbr";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ deepseq ];
  meta = {
    homepage = "http://hunit.sourceforge.net/";
    description = "A unit testing framework for Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
