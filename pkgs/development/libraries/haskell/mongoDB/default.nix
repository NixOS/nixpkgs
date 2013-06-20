{ cabal, binary, bson, cryptohash, liftedBase, monadControl, mtl
, network, parsec, random, randomShuffle, text, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "mongoDB";
  version = "1.4.1";
  sha256 = "1r1ywqy3igcmmwxjy4fjqdnf8m4zqbc8l0nj43h2xwrl86lhfym9";
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
