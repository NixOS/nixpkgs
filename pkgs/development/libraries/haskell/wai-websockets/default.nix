{ cabal, blazeBuilder, caseInsensitive, conduit, fileEmbed
, httpTypes, ioStreams, network, text, transformers, wai
, waiAppStatic, warp, websockets
}:

cabal.mkDerivation (self: {
  pname = "wai-websockets";
  version = "2.1.0.1";
  sha256 = "1ic1wgfp16j6lhypn1psmicafjavbhq5rvm32xqwkb65abhpg571";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    blazeBuilder caseInsensitive conduit fileEmbed httpTypes ioStreams
    network text transformers wai waiAppStatic warp websockets
  ];
  meta = {
    homepage = "http://github.com/yesodweb/wai";
    description = "Provide a bridge betweeen WAI and the websockets package";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
