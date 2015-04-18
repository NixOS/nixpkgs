{ cabal, aeson, errors, HsOpenSSL, ioStreams, lens, lensAeson
, monadLoops, mtl, network, opensslStreams, text, time
, transformers, websockets, wreq
}:

cabal.mkDerivation (self: {
  pname = "slack-api";
  version = "0.2.1";
  sha256 = "1k6p60gb13g09y6isr1r90zw548vs4y1fz34amfhdx79g9zm30hy";
  buildDepends = [
    aeson errors HsOpenSSL ioStreams lens lensAeson monadLoops mtl
    network opensslStreams text time transformers websockets wreq
  ];
  meta = {
    description = "Bindings to the Slack RTM API";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
