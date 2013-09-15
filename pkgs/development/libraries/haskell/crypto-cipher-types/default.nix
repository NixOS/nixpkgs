{ cabal, byteable, securemem }:

cabal.mkDerivation (self: {
  pname = "crypto-cipher-types";
  version = "0.0.5";
  sha256 = "1n0sam5lldhzlcp6ihjika52pb5d12g6r9ln84s7zk7nv59lpqjl";
  buildDepends = [ byteable securemem ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-crypto-cipher";
    description = "Generic cryptography cipher types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
