{ cabal, classyPrelude, conduit, conduitCombinators, hspec
, monadControl, QuickCheck, resourcet, systemFileio, transformers
, void
}:

cabal.mkDerivation (self: {
  pname = "classy-prelude-conduit";
  version = "0.8.0";
  sha256 = "1br2gjzafxgq6ksxl895m5acaffnswd1dhcjppx6gnyfa6i3fq1m";
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
