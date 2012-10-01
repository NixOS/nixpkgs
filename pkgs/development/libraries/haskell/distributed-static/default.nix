{ cabal, binary, rank1dynamic }:

cabal.mkDerivation (self: {
  pname = "distributed-static";
  version = "0.2.0.0";
  sha256 = "04s3iils9ji8bwizvm36r5ihnd11098346br0919dv1x6g67a610";
  buildDepends = [ binary rank1dynamic ];
  meta = {
    homepage = "http://www.github.com/haskell-distributed/distributed-process";
    description = "Compositional, type-safe, polymorphic static values and closures";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
