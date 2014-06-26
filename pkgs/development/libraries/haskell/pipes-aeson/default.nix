{ cabal, aeson, attoparsec, pipes, pipesAttoparsec, pipesBytestring
, pipesParse, transformers
}:

cabal.mkDerivation (self: {
  pname = "pipes-aeson";
  version = "0.4.1";
  sha256 = "06fxl4az5brbivc5db498fc3yawrc2rwnrn20rbssihd0lp9xm1i";
  buildDepends = [
    aeson attoparsec pipes pipesAttoparsec pipesBytestring pipesParse
    transformers
  ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/k0001/pipes-aeson";
    description = "Encode and decode JSON streams using Aeson and Pipes";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
