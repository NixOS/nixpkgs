{ cabal, byteable, securemem }:

cabal.mkDerivation (self: {
  pname = "crypto-cipher-types";
  version = "0.0.4";
  sha256 = "0ipwplw1mn6amjxk2i5sksxvfsnf2fv8rnrgyncl21mp1gbnq7h0";
  buildDepends = [ byteable securemem ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-crypto-cipher";
    description = "Generic cryptography cipher types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
