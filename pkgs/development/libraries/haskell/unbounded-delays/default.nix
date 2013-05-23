{ cabal }:

cabal.mkDerivation (self: {
  pname = "unbounded-delays";
  version = "0.1.0.5";
  sha256 = "109swgxlv3ywf5g0wgm3gp2y7azd6mqf2lfb9sk21dfzcz28aq4k";
  meta = {
    homepage = "https://github.com/basvandijk/unbounded-delays";
    description = "Unbounded thread delays and timeouts";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
