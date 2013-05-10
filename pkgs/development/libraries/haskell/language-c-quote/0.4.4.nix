{ cabal, alex, exceptionMtl, exceptionTransformers, filepath, happy
, haskellSrcMeta, HUnit, mainlandPretty, mtl, srcloc, syb, symbol
, testFramework, testFrameworkHunit
}:

cabal.mkDerivation (self: {
  pname = "language-c-quote";
  version = "0.4.4";
  sha256 = "1g233ja3qy64xcimy9irfb3n8zys00vg1d0s4g3hr48ilc95dl8l";
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
    homepage = "http://www.eecs.harvard.edu/~mainland/";
    description = "C/CUDA/OpenCL quasiquoting library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
