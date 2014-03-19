{ cabal, basicPrelude, chunkedData, conduit, hspec, monoTraversable
, mwcRandom, primitive, silently, systemFileio, systemFilepath
, text, transformers, transformersBase, vector, void
}:

cabal.mkDerivation (self: {
  pname = "conduit-combinators";
  version = "0.2.1";
  sha256 = "0v3b9wiziyynk00fk07nwrk3c032wyr0adrwlkjl89ma1ix220sv";
  buildDepends = [
    chunkedData conduit monoTraversable mwcRandom primitive
    systemFileio systemFilepath text transformers transformersBase
    vector void
  ];
  testDepends = [
    basicPrelude chunkedData hspec monoTraversable mwcRandom silently
    text transformers vector
  ];
  meta = {
    homepage = "https://github.com/fpco/conduit-combinators";
    description = "Commonly used conduit functions, for both chunked and unchunked data";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
