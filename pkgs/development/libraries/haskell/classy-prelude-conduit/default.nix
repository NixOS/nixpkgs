{ cabal, classyPrelude, conduit, conduitCombinators, hspec
, monadControl, QuickCheck, resourcet, systemFileio, transformers
, void
}:

cabal.mkDerivation (self: {
  pname = "classy-prelude-conduit";
  version = "0.9.2";
  sha256 = "07qdhha58yl1dq4mpbyrpjwzk2yhn8dbkg2qg2yaq1j780a6dwcv";
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
