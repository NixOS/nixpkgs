{ cabal }:

cabal.mkDerivation (self: {
  pname = "old-locale";
  version = "1.0.0.6";
  sha256 = "093bmy2vswvll018w142srl0j5vh8944m7qg6qpjclp5b6p55i6z";
  meta = {
    description = "locale library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})

