{ cabal, binary, bson, cryptohash, liftedBase, monadControl, mtl
, network, parsec, random, randomShuffle, text, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "mongoDB";
  version = "1.3.1";
  sha256 = "1qvsb993n5gmchym4zz2pv68mdyir439cfindqdqlvjwam0jf4l5";
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
