{ cabal, binary, bson, cryptohash, hashtables, liftedBase
, monadControl, mtl, network, parsec, random, randomShuffle, text
, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "mongoDB";
  version = "1.4.4";
  sha256 = "11v0k2i0ix67zwm19w1215dslnnqllkc4jlhbs5yva2ix4z7d4gh";
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
