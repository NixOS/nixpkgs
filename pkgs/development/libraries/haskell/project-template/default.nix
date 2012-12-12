{ cabal, base64Bytestring, base64Conduit, classyPreludeConduit
, conduit, mtl, resourcet, systemFileio, systemFilepath, text
, transformers
}:

cabal.mkDerivation (self: {
  pname = "project-template";
  version = "0.1.1";
  sha256 = "186hqfhhl77yq9gqiw59jbnkk7xmpljqfwwilzjkjknf3ifhs5na";
  buildDepends = [
    base64Bytestring base64Conduit classyPreludeConduit conduit mtl
    resourcet systemFileio systemFilepath text transformers
  ];
  meta = {
    homepage = "https://github.com/fpco/haskell-ide";
    description = "Specify Haskell project templates and generate files";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
