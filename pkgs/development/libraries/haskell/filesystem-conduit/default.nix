{ cabal, conduit, systemFileio, systemFilepath, text, transformers
}:

cabal.mkDerivation (self: {
  pname = "filesystem-conduit";
  version = "1.0.0";
  sha256 = "1fz3iihcqpg6m3svjqdg8lvkpza955qn8cbs9b3w333vxkglhi6v";
  buildDepends = [
    conduit systemFileio systemFilepath text transformers
  ];
  meta = {
    homepage = "http://github.com/snoyberg/conduit";
    description = "Use system-filepath data types with conduits";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
