{ cabal, binary, bson, cryptohash, liftedBase, monadControl, mtl
, network, parsec, random, randomShuffle, text, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "mongoDB";
  version = "1.4.0";
  sha256 = "1cj73k6lfpxmfaigqwwglnncfl1ikz6yjgs0d9f6k42kwysbddwz";
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
