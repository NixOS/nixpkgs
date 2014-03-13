{ cabal, blazeBuilder, caseInsensitive, conduit, fileEmbed
, httpTypes, ioStreams, network, text, transformers, wai
, waiAppStatic, warp, websockets
}:

cabal.mkDerivation (self: {
  pname = "wai-websockets";
  version = "2.1.0";
  sha256 = "094imqhkn4ghifgp2qhs4hnby3zzdd84fhmyvvy7igcpz1rmll7a";
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
