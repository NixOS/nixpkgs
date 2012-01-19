{ cabal, attoparsec, conduit, text, transformers }:

cabal.mkDerivation (self: {
  pname = "attoparsec-conduit";
  version = "0.0.1";
  sha256 = "04r3ywzjm39rmd0pka8537c8n6d4l6scgzkqzplmi6nb0kikgb6i";
  buildDepends = [ attoparsec conduit text transformers ];
  meta = {
    homepage = "http://github.com/snoyberg/conduit";
    description = "Turn attoparsec parsers into sinks";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
