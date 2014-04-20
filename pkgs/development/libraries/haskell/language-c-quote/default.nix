{ cabal, alex, exceptionMtl, exceptionTransformers, filepath, happy
, haskellSrcMeta, HUnit, mainlandPretty, mtl, srcloc, syb, symbol
, testFramework, testFrameworkHunit
}:

cabal.mkDerivation (self: {
  pname = "language-c-quote";
  version = "0.7.7";
  sha256 = "0rj508hfv9xf30rfjhalz3yfb15vp4r4acdj8aahwfnbls2qb37v";
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
