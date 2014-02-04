{ cabal, aeson, attoparsec, pipes, pipesAttoparsec, pipesParse
, transformers
}:

cabal.mkDerivation (self: {
  pname = "pipes-aeson";
  version = "0.2.1";
  sha256 = "19zrbk9jbls8zsnhx8bm9dzd7rxvf98bpjkr3k9ggmx2g5p08mgz";
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
