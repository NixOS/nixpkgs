{ cabal, blazeBuilder, blazeBuilderConduit, conduit, httpTypes
, transformers, wai, warp, zlibConduit
}:

cabal.mkDerivation (self: {
  pname = "wai-handler-launch";
  version = "2.0.1.1";
  sha256 = "10izbri1a8mjb2q4r1badw63qbp3vxnw5v2hzskq6911bckqkskc";
  buildDepends = [
    blazeBuilder blazeBuilderConduit conduit httpTypes transformers wai
    warp zlibConduit
  ];
  meta = {
    description = "Launch a web app in the default browser";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
