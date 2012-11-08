{ cabal, base64Bytestring, classyPreludeConduit, conduit, mtl
, systemFileio, systemFilepath, text, transformers
}:

cabal.mkDerivation (self: {
  pname = "project-template";
  version = "0.1.0.1";
  sha256 = "0ahmdlfn48yz8fj7199w0qsa1dbbxr21bs9hq1lnm3s2p4qiki23";
  buildDepends = [
    base64Bytestring classyPreludeConduit conduit mtl systemFileio
    systemFilepath text transformers
  ];
  meta = {
    homepage = "https://github.com/fpco/haskell-ide";
    description = "Specify Haskell project templates and generate files";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
