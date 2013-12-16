{ cabal, filepath, mtl, QuickCheck, random, regexBase, stm, text
, time, vector, vty
}:

cabal.mkDerivation (self: {
  pname = "vty-ui";
  version = "1.6.1";
  sha256 = "013a4wlhrhsbkh9wd8dxppn9aa0l7cfrgn3na6cifry34d96ql9d";
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
