{ cabal, byteable, securemem }:

cabal.mkDerivation (self: {
  pname = "crypto-cipher-types";
  version = "0.0.6";
  sha256 = "1gw3nmf242fbmwhpwk1v1sxhvw1dcy9l06aj6ag0wqb12qn2bqmg";
  buildDepends = [ byteable securemem ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-crypto-cipher";
    description = "Generic cryptography cipher types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
