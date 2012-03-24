{ cabal, binary, bson, cryptohash, liftedBase, monadControl, mtl
, network, parsec, random, randomShuffle, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "mongoDB";
  version = "1.2.0";
  sha256 = "0rffa13p889mxbbkj2bmqy3yada3mrhngvp8pp7qvrll1acm7s13";
  buildDepends = [
    binary bson cryptohash liftedBase monadControl mtl network parsec
    random randomShuffle transformersBase
  ];
  meta = {
    homepage = "http://github.com/TonyGen/mongoDB-haskell";
    description = "Driver (client) for MongoDB, a free, scalable, fast, document DBMS";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
