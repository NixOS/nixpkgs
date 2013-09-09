{ cabal, base64Bytestring, base64Conduit, basicPrelude, conduit
, hspec, mtl, QuickCheck, resourcet, systemFileio, systemFilepath
, text, transformers
}:

cabal.mkDerivation (self: {
  pname = "project-template";
  version = "0.1.3.2";
  sha256 = "076xq5hwi7bfn3cmx8zd19vnj6lj2p7qm2waam94qqw2m466xq50";
  buildDepends = [
    base64Bytestring base64Conduit basicPrelude conduit mtl resourcet
    systemFileio systemFilepath text transformers
  ];
  testDepends = [
    base64Bytestring basicPrelude conduit hspec QuickCheck
    systemFilepath text transformers
  ];
  meta = {
    homepage = "https://github.com/fpco/haskell-ide";
    description = "Specify Haskell project templates and generate files";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
