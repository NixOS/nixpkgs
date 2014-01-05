{ cabal, alex, exceptionMtl, exceptionTransformers, filepath, happy
, haskellSrcMeta, HUnit, mainlandPretty, mtl, srcloc, syb, symbol
, testFramework, testFrameworkHunit
}:

cabal.mkDerivation (self: {
  pname = "language-c-quote";
  version = "0.7.6";
  sha256 = "15sfasbrr9wzqkwv9xg9nvb3gnn4drkll3b3cappiyzkmawp2hkr";
  buildDepends = [
    exceptionMtl exceptionTransformers filepath haskellSrcMeta
    mainlandPretty mtl srcloc syb symbol
  ];
  testDepends = [
    HUnit srcloc symbol testFramework testFrameworkHunit
  ];
  buildTools = [ alex happy ];
  jailbreak = true;
  meta = {
    homepage = "http://www.cs.drexel.edu/~mainland/";
    description = "C/CUDA/OpenCL/Objective-C quasiquoting library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
