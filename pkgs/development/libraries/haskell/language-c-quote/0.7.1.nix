{ cabal, alex, exceptionMtl, exceptionTransformers, filepath, happy
, haskellSrcMeta, HUnit, mainlandPretty, mtl, srcloc, syb, symbol
, testFramework, testFrameworkHunit
}:

cabal.mkDerivation (self: {
  pname = "language-c-quote";
  version = "0.7.1";
  sha256 = "14gh944wpwg4csxwswr9jlll4p5wc3x1fhbqsfh9lqf98ys7ij3z";
  buildDepends = [
    exceptionMtl exceptionTransformers filepath haskellSrcMeta
    mainlandPretty mtl srcloc syb symbol
  ];
  testDepends = [
    HUnit srcloc symbol testFramework testFrameworkHunit
  ];
  buildTools = [ alex happy ];
  meta = {
    homepage = "http://www.eecs.harvard.edu/~mainland/";
    description = "C/CUDA/OpenCL/Objective-C quasiquoting library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
