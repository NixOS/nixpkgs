{ cabal, binary, bson, cryptohash, hashtables, liftedBase
, monadControl, mtl, network, parsec, random, randomShuffle, text
, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "mongoDB";
  version = "1.4.2";
  sha256 = "15m23q17q8asrsa27mb73ydim1yjrxl06lgf7z8w4r6jy6lk34hf";
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
