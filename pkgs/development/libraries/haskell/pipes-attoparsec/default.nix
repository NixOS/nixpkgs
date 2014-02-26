{ cabal, attoparsec, HUnit, mmorph, pipes, pipesParse, tasty
, tastyHunit, text, transformers
}:

cabal.mkDerivation (self: {
  pname = "pipes-attoparsec";
  version = "0.4.0.1";
  sha256 = "0f536x0l135b5pd14l6lri7kinwh2m4p7qw054lacw362y7004zf";
  buildDepends = [ attoparsec pipes pipesParse text transformers ];
  testDepends = [
    attoparsec HUnit mmorph pipes pipesParse tasty tastyHunit text
    transformers
  ];
  meta = {
    homepage = "https://github.com/k0001/pipes-attoparsec";
    description = "Attoparsec and Pipes integration";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
