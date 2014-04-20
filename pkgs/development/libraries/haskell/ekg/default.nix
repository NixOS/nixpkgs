{ cabal, aeson, filepath, network, snapCore, snapServer, text, time
, transformers, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "ekg";
  version = "0.3.1.4";
  sha256 = "0hr9962yx463rq53xfqfm7vlv9izn47v3css3m6n4v694qlyz95i";
  buildDepends = [
    aeson filepath network snapCore snapServer text time transformers
    unorderedContainers
  ];
  meta = {
    homepage = "https://github.com/tibbe/ekg";
    description = "Remote monitoring of processes";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
