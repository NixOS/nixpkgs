{ cabal, transformers }:

cabal.mkDerivation (self: {
  pname = "union-find";
  version = "0.2";
  sha256 = "1v7hj42j9w6jlzi56jg8rh4p58gfs1c5dx30wd1qqvn0p0mnihp6";
  buildDepends = [ transformers ];
  meta = {
    homepage = "http://github.com/nominolo/union-find";
    description = "Efficient union and equivalence testing of sets";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
