{ cabal, binary, bson, cryptohash, hashtables, liftedBase
, monadControl, mtl, network, parsec, random, randomShuffle, text
, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "mongoDB";
  version = "2.0";
  sha256 = "1dspx1x20903i44i825ziwmvaax75m8g08kz97cv34077bdir80h";
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
