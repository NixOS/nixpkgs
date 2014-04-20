{ cabal, aeson, attoparsec, pipes, pipesAttoparsec, pipesBytestring
, pipesParse, transformers
}:

cabal.mkDerivation (self: {
  pname = "pipes-aeson";
  version = "0.3.0";
  sha256 = "1kckdllw5xnh8z92gjw5swyxp9km879wqfly7af3iirwhickk4vn";
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
