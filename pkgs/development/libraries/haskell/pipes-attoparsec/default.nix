{ cabal, attoparsec, HUnit, mmorph, pipes, pipesParse, tasty
, tastyHunit, text, transformers
}:

cabal.mkDerivation (self: {
  pname = "pipes-attoparsec";
  version = "0.4.0";
  sha256 = "0xffqxsh8yvfdk39mdgkf0l2v284fr31nz5k16dq752p63fnczkw";
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
