{ cabal, hspec }:

cabal.mkDerivation (self: {
  pname = "word8";
  version = "0.0.3";
  sha256 = "1k5sq91pidgw7w8fc62k9gl8iynb65pcza6mjx8pa3n2lslp7125";
  testDepends = [ hspec ];
  meta = {
    description = "Word8 library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
