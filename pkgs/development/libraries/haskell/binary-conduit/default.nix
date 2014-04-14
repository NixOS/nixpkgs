{ cabal, binary, conduit, hspec, QuickCheck, quickcheckAssertions
, resourcet, vector
}:

cabal.mkDerivation (self: {
  pname = "binary-conduit";
  version = "1.2.1.1";
  sha256 = "0f6ki793fbgxpsqadfj796b4rbv6zhn4v4rrd48r48zzw9hmxmzd";
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
