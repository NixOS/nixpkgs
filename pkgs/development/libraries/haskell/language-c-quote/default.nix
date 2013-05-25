{ cabal, alex, exceptionMtl, exceptionTransformers, filepath, happy
, haskellSrcMeta, HUnit, mainlandPretty, mtl, srcloc, syb, symbol
, testFramework, testFrameworkHunit
}:

cabal.mkDerivation (self: {
  pname = "language-c-quote";
  version = "0.7.2";
  sha256 = "01ki78qh39gbd9md3pq783vx2p86gyzhclci7pcppz2rd3man51m";
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
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
