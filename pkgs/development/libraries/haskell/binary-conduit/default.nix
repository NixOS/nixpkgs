{ cabal, binary, conduit, hspec, QuickCheck, quickcheckAssertions
, resourcet, vector
}:

cabal.mkDerivation (self: {
  pname = "binary-conduit";
  version = "1.2.2";
  sha256 = "12dgqydc4zj1ffrcfqpd1dg40dc9hpynj1j69611kzpcqbj275pf";
  buildDepends = [ binary conduit resourcet vector ];
  testDepends = [
    binary conduit hspec QuickCheck quickcheckAssertions resourcet
  ];
  meta = {
    homepage = "http://github.com/qnikst/binary-conduit";
    description = "data serialization/deserialization conduit library";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
