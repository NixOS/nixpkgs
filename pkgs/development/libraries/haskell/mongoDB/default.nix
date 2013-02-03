{ cabal, binary, bson, cryptohash, liftedBase, monadControl, mtl
, network, parsec, random, randomShuffle, text, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "mongoDB";
  version = "1.3.2";
  sha256 = "0gv0i2z6f797ibjfp16ax2aiqa66sclxjy8sabrwydwcyr96xb4y";
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
