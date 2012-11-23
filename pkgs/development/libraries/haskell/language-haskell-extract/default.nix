{ cabal, haskellSrcExts, regexPosix }:

cabal.mkDerivation (self: {
  pname = "language-haskell-extract";
  version = "0.2.3";
  sha256 = "0fz1nin596ihlh77pafzpdf46br1k3pxcxyml2rvly6g0h3yjgpr";
  buildDepends = [ haskellSrcExts regexPosix ];
  meta = {
    homepage = "http://github.com/finnsson/template-helper";
    description = "Module to automatically extract functions from the local code";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
