{ cabal, blazeBuilder, caseInsensitive, fileEmbed, httpTypes
, ioStreams, network, text, transformers, wai, waiAppStatic, warp
, websockets
}:

cabal.mkDerivation (self: {
  pname = "wai-websockets";
  version = "3.0.0";
  sha256 = "0bpzkh9a5j0a282z4dj9dqnjsgd0g8gyvvp0xm0a53582zfhfi5s";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    blazeBuilder caseInsensitive fileEmbed httpTypes ioStreams network
    text transformers wai waiAppStatic warp websockets
  ];
  meta = {
    homepage = "http://github.com/yesodweb/wai";
    description = "Provide a bridge betweeen WAI and the websockets package";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
