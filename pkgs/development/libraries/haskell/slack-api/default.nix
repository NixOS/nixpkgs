{ cabal, aeson, errors, HsOpenSSL, ioStreams, lens, lensAeson
, monadLoops, mtl, network, opensslStreams, text, time
, transformers, websockets, wreq
}:

cabal.mkDerivation (self: {
  pname = "slack-api";
  version = "0.2";
  sha256 = "0gw6x57nnc16fm963l8z96cm4xapr4nbbmrbpx73k928a07fdq8j";
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
