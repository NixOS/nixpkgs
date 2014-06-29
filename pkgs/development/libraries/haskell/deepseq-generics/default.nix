{ cabal, deepseq, HUnit, testFramework, testFrameworkHunit }:

cabal.mkDerivation (self: {
  pname = "deepseq-generics";
  version = "0.1.1.1";
  sha256 = "1icc2gxsbnjjl150msnyysvr9r14kb6s2gm3izrj5a3mwf6l7s08";
  buildDepends = [ deepseq ];
  testDepends = [ deepseq HUnit testFramework testFrameworkHunit ];
  meta = {
    homepage = "https://github.com/hvr/deepseq-generics";
    description = "GHC.Generics-based Control.DeepSeq.rnf implementation";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
