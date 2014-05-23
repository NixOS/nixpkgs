{ cabal, filepath, mtl, QuickCheck, random, regexBase, stm, text
, time, vector, vty
}:

cabal.mkDerivation (self: {
  pname = "vty-ui";
  version = "1.7";
  sha256 = "1wd7ada3x7d5rhl4z3h29m9h42513vbz6dp49xhn4j806mi164nd";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    filepath mtl QuickCheck random regexBase stm text time vector vty
  ];
  jailbreak = true;
  meta = {
    homepage = "http://jtdaugherty.github.com/vty-ui/";
    description = "An interactive terminal user interface library for Vty";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
