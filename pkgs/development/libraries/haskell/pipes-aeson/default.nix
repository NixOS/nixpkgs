{ cabal, aeson, attoparsec, pipes, pipesAttoparsec, pipesBytestring
, pipesParse, transformers
}:

cabal.mkDerivation (self: {
  pname = "pipes-aeson";
  version = "0.4";
  sha256 = "0cz9av3w8h2gh3cz7gs3ikplf60a111wcsr3z6vi8gqlmmgmck07";
  buildDepends = [
    aeson attoparsec pipes pipesAttoparsec pipesBytestring pipesParse
    transformers
  ];
  meta = {
    homepage = "https://github.com/k0001/pipes-aeson";
    description = "Encode and decode JSON streams using Aeson and Pipes";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
