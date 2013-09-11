{ cabal, aeson, attoparsec, pipes, pipesAttoparsec, pipesParse
, transformers
}:

cabal.mkDerivation (self: {
  pname = "pipes-aeson";
  version = "0.2.0";
  sha256 = "12y5dywrhx3mvmlq26bc1cwybnclqbf91zvlz5ig2pi01ji3q94y";
  buildDepends = [
    aeson attoparsec pipes pipesAttoparsec pipesParse transformers
  ];
  meta = {
    homepage = "https://github.com/k0001/pipes-aeson";
    description = "Encode and decode JSON streams using Aeson and Pipes";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
