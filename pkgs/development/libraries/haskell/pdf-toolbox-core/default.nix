{ cabal, attoparsec, errors, ioStreams, transformers, zlibBindings
}:

cabal.mkDerivation (self: {
  pname = "pdf-toolbox-core";
  version = "0.0.2.1";
  sha256 = "14jj6xprzh2k1njal0mgapkm3xivy8370p9kdjxha9gnwmc581df";
  buildDepends = [
    attoparsec errors ioStreams transformers zlibBindings
  ];
  meta = {
    homepage = "https://github.com/Yuras/pdf-toolbox";
    description = "A collection of tools for processing PDF files";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ ianwookim ];
  };
})
