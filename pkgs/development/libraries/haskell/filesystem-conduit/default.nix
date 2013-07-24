{ cabal, blazeBuilder, conduit, hspec, QuickCheck, systemFileio
, systemFilepath, text, transformers
}:

cabal.mkDerivation (self: {
  pname = "filesystem-conduit";
  version = "1.0.0.1";
  sha256 = "04l8i97mr0jzkc7vc77j885n45qd2qyn5kmzxyckp3za96sjsqqw";
  buildDepends = [
    conduit systemFileio systemFilepath text transformers
  ];
  testDepends = [
    blazeBuilder conduit hspec QuickCheck text transformers
  ];
  meta = {
    homepage = "http://github.com/snoyberg/conduit";
    description = "Use system-filepath data types with conduits";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
