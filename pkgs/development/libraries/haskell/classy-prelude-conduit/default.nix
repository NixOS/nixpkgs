{ cabal, classyPrelude, conduit, hspec, monadControl, QuickCheck
, resourcet, transformers, void, xmlConduit
}:

cabal.mkDerivation (self: {
  pname = "classy-prelude-conduit";
  version = "0.5.2";
  sha256 = "11krzhy78z0srjy5g6h8ssv5n3ml8ryx92x0zdjigqxw4zq9ic72";
  buildDepends = [
    classyPrelude conduit monadControl resourcet transformers void
    xmlConduit
  ];
  testDepends = [ conduit hspec QuickCheck transformers ];
  meta = {
    homepage = "https://github.com/snoyberg/classy-prelude";
    description = "conduit instances for classy-prelude";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
