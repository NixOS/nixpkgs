{ cabal, deepseq, primitive, vector }:

cabal.mkDerivation (self: {
  pname = "hybrid-vectors";
  version = "0.1";
  sha256 = "0a5ry6xmkr0zjz0kp7qbm7kdz5yr9842gy116902djppmdn5dq05";
  buildDepends = [ deepseq primitive vector ];
  meta = {
    homepage = "http://github.com/ekmett/hybrid-vectors";
    description = "Hybrid vectors e.g. Mixed Boxed/Unboxed vectors";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
