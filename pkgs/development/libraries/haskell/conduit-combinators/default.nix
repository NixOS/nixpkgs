{ cabal, basicPrelude, chunkedData, conduit, hspec, monoTraversable
, mwcRandom, primitive, silently, systemFileio, systemFilepath
, text, transformers, transformersBase, unixCompat, vector, void
}:

cabal.mkDerivation (self: {
  pname = "conduit-combinators";
  version = "0.2.2";
  sha256 = "0b196srw2vbs46zz2m3mb1cbw7pza8q429r5b280bw6vby9h6jbr";
  buildDepends = [
    chunkedData conduit monoTraversable mwcRandom primitive
    systemFileio systemFilepath text transformers transformersBase
    unixCompat vector void
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
