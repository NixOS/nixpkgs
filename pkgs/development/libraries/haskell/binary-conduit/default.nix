{ cabal, binary, conduit, hspec, QuickCheck, quickcheckAssertions
, vector
}:

cabal.mkDerivation (self: {
  pname = "binary-conduit";
  version = "1.2";
  sha256 = "1m58zgmivapn51gs5983vpsivzkki94kkac014mwvnp90q46nkvx";
  buildDepends = [ binary conduit vector ];
  testDepends = [
    binary conduit hspec QuickCheck quickcheckAssertions
  ];
  meta = {
    homepage = "http://github.com/qnikst/binary-conduit";
    description = "data serialization/deserialization conduit library";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
