{ cabal, binary, bson, cryptohash, monadControl, mtl, network
, parsec, random, randomShuffle
}:

cabal.mkDerivation (self: {
  pname = "mongoDB";
  version = "1.1.1";
  sha256 = "0hy47kvswm4g85c3lb75fvdrcnrcbmjrhk15r1jjriwzqicgiimz";
  buildDepends = [
    binary bson cryptohash monadControl mtl network parsec random
    randomShuffle
  ];
  meta = {
    homepage = "http://github.com/TonyGen/mongoDB-haskell";
    description = "Driver (client) for MongoDB, a free, scalable, fast, document DBMS";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
