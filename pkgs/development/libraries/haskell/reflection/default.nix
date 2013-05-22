{ cabal, tagged }:

cabal.mkDerivation (self: {
  pname = "reflection";
  version = "1.3.2";
  sha256 = "0jmdygvmvhw20aqjk7k0jah93ggfgf2bgq5zpwnz9bwgi9gs17x6";
  buildDepends = [ tagged ];
  meta = {
    homepage = "http://github.com/ekmett/reflection";
    description = "Reifies arbitrary terms into types that can be reflected back into terms";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
