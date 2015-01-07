{ cabal, aeson, errors, HsOpenSSL, ioStreams, lens, lensAeson
, monadLoops, mtl, network, opensslStreams, text, time
, transformers, websockets, wreq
}:

cabal.mkDerivation (self: {
  pname = "slack-api";
  version = "0.1";
  sha256 = "1f7ba8saf2s78qcc95z2iqq36pz7mskqzm1wlfdcwqb77vr7hn44";
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

