{ cabal, binary, bson, cryptohash, liftedBase, monadControl, mtl
, network, parsec, random, randomShuffle, text, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "mongoDB";
  version = "1.3.0";
  sha256 = "1l6r55bicjdybn8jn9rp94aamjqy5j5qs2775m05aba8svsl4kma";
  buildDepends = [
    binary bson cryptohash liftedBase monadControl mtl network parsec
    random randomShuffle text transformersBase
  ];
  meta = {
    homepage = "http://github.com/selectel/mongodb-haskell";
    description = "Driver (client) for MongoDB, a free, scalable, fast, document DBMS";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
