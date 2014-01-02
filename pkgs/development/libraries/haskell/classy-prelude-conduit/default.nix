{ cabal, classyPrelude, conduit, hspec, monadControl, QuickCheck
, resourcet, systemFileio, transformers, void
}:

cabal.mkDerivation (self: {
  pname = "classy-prelude-conduit";
  version = "0.7.0";
  sha256 = "0njhfqbcbsy1rv61fc4xqzqlb68hzqg9cr31f8bs6h7pa12n38zq";
  buildDepends = [
    classyPrelude conduit monadControl resourcet systemFileio
    transformers void
  ];
  testDepends = [ conduit hspec QuickCheck transformers ];
  meta = {
    homepage = "https://github.com/snoyberg/classy-prelude";
    description = "conduit instances for classy-prelude";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
