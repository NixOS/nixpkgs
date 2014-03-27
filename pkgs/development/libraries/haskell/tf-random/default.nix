{ cabal, primitive, random, time }:

cabal.mkDerivation (self: {
  pname = "tf-random";
  version = "0.4";
  sha256 = "0yi7699zswpsn9a39ccqkyd0117sppjnqggclnhs1wm7ql1glc27";
  buildDepends = [ primitive random time ];
  meta = {
    description = "High-quality splittable pseudorandom number generator";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
