{ cabal, blazeBuilder, caseInsensitive, conduit, fileEmbed
, httpTypes, ioStreams, network, text, transformers, wai
, waiAppStatic, warp, websockets
}:

cabal.mkDerivation (self: {
  pname = "wai-websockets";
  version = "2.1.0.2";
  sha256 = "16hff38x6fpmp4r1wkjd922s02v5na8zwy6mq5f5gsj7b70n2ww2";
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
