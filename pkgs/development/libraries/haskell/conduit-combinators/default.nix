{ cabal, basicPrelude, chunkedData, conduit, hspec, monoTraversable
, primitive, silently, systemFileio, systemFilepath, text
, transformers, transformersBase, vector
}:

cabal.mkDerivation (self: {
  pname = "conduit-combinators";
  version = "0.2.0.0";
  sha256 = "0r5s1m31ncg1m9sm8n2212r9mm4hjrxc3a92divkhcxwijadzghc";
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
