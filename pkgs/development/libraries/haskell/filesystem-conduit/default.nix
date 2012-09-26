{ cabal, conduit, systemFileio, systemFilepath, text, transformers
}:

cabal.mkDerivation (self: {
  pname = "filesystem-conduit";
  version = "0.5.0.1";
  sha256 = "1rpyrvs9hsi86zj6rghv91jn5lcx9wppg1wa4gp976kmagd4wl93";
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
