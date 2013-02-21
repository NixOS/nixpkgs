{ cabal, base64Bytestring, base64Conduit, classyPrelude, conduit
, mtl, resourcet, systemFileio, systemFilepath, text, transformers
}:

cabal.mkDerivation (self: {
  pname = "project-template";
  version = "0.1.3";
  sha256 = "1nsc4i3s9a7d0nysswhylvnr79z0ax9biiwr7b6jn7jzx0f2bdmm";
  buildDepends = [
    base64Bytestring base64Conduit classyPrelude conduit mtl resourcet
    systemFileio systemFilepath text transformers
  ];
  meta = {
    homepage = "https://github.com/fpco/haskell-ide";
    description = "Specify Haskell project templates and generate files";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
