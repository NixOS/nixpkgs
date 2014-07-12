{ cabal, aeson, ekgCore, filepath, network, snapCore, snapServer
, text, time, transformers, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "ekg";
  version = "0.4.0.1";
  sha256 = "09pjsd9jr91whdhv36fkb36ivvvcr415g90a798i86vl8mklgnyx";
  buildDepends = [
    aeson ekgCore filepath network snapCore snapServer text time
    transformers unorderedContainers
  ];
  meta = {
    homepage = "https://github.com/tibbe/ekg";
    description = "Remote monitoring of processes";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
