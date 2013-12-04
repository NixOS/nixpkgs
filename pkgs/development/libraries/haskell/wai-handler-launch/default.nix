{ cabal, blazeBuilder, blazeBuilderConduit, conduit, httpTypes
, transformers, wai, warp, zlibConduit
}:

cabal.mkDerivation (self: {
  pname = "wai-handler-launch";
  version = "1.3.1.5";
  sha256 = "1iz36j7lzl5c9b2hacxv4v5gfzkfvgj7hlb5xz4r14ca4w5fzzfj";
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
