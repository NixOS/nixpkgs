{ cabal, base64Bytestring, base64Conduit, classyPreludeConduit
, conduit, mtl, resourcet, systemFileio, systemFilepath, text
, transformers
}:

cabal.mkDerivation (self: {
  pname = "project-template";
  version = "0.1.2";
  sha256 = "16rgarx78jwiimh3q8flxvmfraxmc1dxl8r04q4j1p9ap3mnvg61";
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
