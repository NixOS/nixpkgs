{ cabal, binary, rank1dynamic }:

cabal.mkDerivation (self: {
  pname = "distributed-static";
  version = "0.2.1";
  sha256 = "0cdwizm4fr2akw7hsqdrvqk06h1lybpxjiczv3kmd0lyc4cb7kyc";
  buildDepends = [ binary rank1dynamic ];
  meta = {
    homepage = "http://www.github.com/haskell-distributed/distributed-process";
    description = "Compositional, type-safe, polymorphic static values and closures";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
