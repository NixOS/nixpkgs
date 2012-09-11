{ cabal, alex, exceptionMtl, exceptionTransformers, filepath, happy
, haskellSrcMeta, mainlandPretty, mtl, srcloc, syb, symbol
}:

cabal.mkDerivation (self: {
  pname = "language-c-quote";
  version = "0.3.2";
  sha256 = "1pxrag9ws93rsqrsxcyxg07pvp2qw0f19yj2b40ynwzk112nkd16";
  buildDepends = [
    exceptionMtl exceptionTransformers filepath haskellSrcMeta
    mainlandPretty mtl srcloc syb symbol
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
