{ cabal, basicPrelude, chunkedData, conduit, hspec, monoTraversable
, primitive, silently, systemFileio, systemFilepath, text
, transformers, transformersBase, vector
}:

cabal.mkDerivation (self: {
  pname = "conduit-combinators";
  version = "0.2.0.1";
  sha256 = "0hmy398kk37n5l4pacb2a0z9h9f1kl6vva9gsph1kiqnnz7sbr4r";
  buildDepends = [
    chunkedData conduit monoTraversable primitive systemFileio
    systemFilepath text transformers transformersBase vector
  ];
  testDepends = [
    basicPrelude chunkedData hspec monoTraversable silently text
    transformers vector
  ];
  meta = {
    homepage = "https://github.com/fpco/conduit-combinators";
    description = "Commonly used conduit functions, for both chunked and unchunked data";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
