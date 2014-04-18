{ cabal, binary, fastLogger, hspec, liftedBase, monadControl
, monadLogger, pcreLight, text, time, transformers, vectorSpace
}:

cabal.mkDerivation (self: {
  pname = "logging";
  version = "1.4.0";
  sha256 = "0xkk6j9wa5n0qg0wp7a9bwaz328hrjk1fwanpa515hh3gvz62g94";
  buildDepends = [
    binary fastLogger liftedBase monadControl monadLogger pcreLight
    text time transformers vectorSpace
  ];
  testDepends = [ hspec monadLogger ];
  meta = {
    description = "Simplified logging in IO for application writers";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
