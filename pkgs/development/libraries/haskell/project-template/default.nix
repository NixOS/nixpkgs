{ cabal, base64Bytestring, conduit, hspec, mtl, QuickCheck
, resourcet, systemFileio, systemFilepath, text, transformers
}:

cabal.mkDerivation (self: {
  pname = "project-template";
  version = "0.1.4";
  sha256 = "1fmpb7jrn7mry8wq5jyxhkwyr61fknhi7p8mmqs7xn8lxwbj5904";
  buildDepends = [
    base64Bytestring conduit mtl resourcet systemFileio systemFilepath
    text transformers
  ];
  testDepends = [
    base64Bytestring conduit hspec QuickCheck systemFilepath text
    transformers
  ];
  meta = {
    homepage = "https://github.com/fpco/haskell-ide";
    description = "Specify Haskell project templates and generate files";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
