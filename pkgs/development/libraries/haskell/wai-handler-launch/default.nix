{ cabal, blazeBuilder, httpTypes, streamingCommons, transformers
, wai, warp
}:

cabal.mkDerivation (self: {
  pname = "wai-handler-launch";
  version = "3.0.0";
  sha256 = "1dv7w151szjkg9968v870abz11a440pdzy50zwm0xl6blk392nmk";
  buildDepends = [
    blazeBuilder httpTypes streamingCommons transformers wai warp
  ];
  meta = {
    description = "Launch a web app in the default browser";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
