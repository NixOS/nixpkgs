{ cabal, hspec, QuickCheck }:

cabal.mkDerivation (self: {
  pname = "setenv";
  version = "0.1.0";
  sha256 = "04w42bpfbrs5crjp19zzi9dg61xpz4wvmjs2vc7q7qxblyhdfdsy";
  testDepends = [ hspec QuickCheck ];
  meta = {
    description = "A cross-platform library for setting environment variables";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
