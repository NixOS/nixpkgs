{ cabal, binary, bson, cryptohash, hashtables, liftedBase
, monadControl, mtl, network, parsec, random, randomShuffle, text
, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "mongoDB";
  version = "1.5.0";
  sha256 = "0dvy8pa79c26hcngds6nnwnayrhsyz1flj18m9bcyrcvwb5q3dd6";
  buildDepends = [
    binary bson cryptohash hashtables liftedBase monadControl mtl
    network parsec random randomShuffle text transformersBase
  ];
  meta = {
    homepage = "http://github.com/selectel/mongodb-haskell";
    description = "Driver (client) for MongoDB, a free, scalable, fast, document DBMS";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
