{ cabal, conduit, systemFileio, systemFilepath, text, transformers
}:

cabal.mkDerivation (self: {
  pname = "filesystem-conduit";
  version = "0.5.0.2";
  sha256 = "0vpxl32k6734vli8nky9cwyabw9alvpjm0g5q822yj9rk2439yfq";
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
