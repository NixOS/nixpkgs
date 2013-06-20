{ cabal, cereal, filepath, knob, monadLoops, randomFu, regexBase
, regexPcre, semigroups, text, utf8String, vector
}:

cabal.mkDerivation (self: {
  pname = "misfortune";
  version = "0.1.1.1";
  sha256 = "0knb31jxxn7zds13a90d4lir39386nwzd181mlzkrw5niw1zwmhb";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    cereal filepath knob monadLoops randomFu regexBase regexPcre
    semigroups text utf8String vector
  ];
  meta = {
    homepage = "https://github.com/mokus0/misfortune";
    description = "fortune-mod clone";
    license = self.stdenv.lib.licenses.publicDomain;
    platforms = self.ghc.meta.platforms;
  };
})
