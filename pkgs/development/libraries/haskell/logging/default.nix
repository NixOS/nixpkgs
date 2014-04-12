{ cabal, binary, fastLogger, hspec, liftedBase, monadControl
, monadLogger, pcreLight, text, thyme, transformers, vectorSpace
}:

cabal.mkDerivation (self: {
  pname = "logging";
  version = "1.3.0";
  sha256 = "1d2is6p828xvh59f9b971xf0w2l229652rniccxpm2mcfs893c79";
  buildDepends = [
    binary fastLogger liftedBase monadControl monadLogger pcreLight
    text thyme transformers vectorSpace
  ];
  testDepends = [ hspec monadLogger ];
  meta = {
    description = "Simplified logging in IO for application writers";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
