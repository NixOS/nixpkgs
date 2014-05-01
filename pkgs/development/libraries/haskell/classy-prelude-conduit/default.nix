{ cabal, classyPrelude, conduit, conduitCombinators, hspec
, monadControl, QuickCheck, resourcet, systemFileio, transformers
, void
}:

cabal.mkDerivation (self: {
  pname = "classy-prelude-conduit";
  version = "0.9.1";
  sha256 = "1y3jxhly9y1yhr2qz3b1jf6sg4s0mwq9xq1mp765wa20hmwjayvg";
  buildDepends = [
    classyPrelude conduit conduitCombinators monadControl resourcet
    systemFileio transformers void
  ];
  testDepends = [ conduit hspec QuickCheck transformers ];
  meta = {
    homepage = "https://github.com/snoyberg/classy-prelude";
    description = "conduit instances for classy-prelude";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
