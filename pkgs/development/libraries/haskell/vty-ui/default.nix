{ cabal, filepath, mtl, QuickCheck, random, regexBase, stm, text
, time, vector, vty
}:

cabal.mkDerivation (self: {
  pname = "vty-ui";
  version = "1.6";
  sha256 = "0chwgzzk2pl9kppd9r6h2azbqc668xpdrrk5y415yi8wcw61s0bc";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    filepath mtl QuickCheck random regexBase stm text time vector vty
  ];
  meta = {
    homepage = "http://jtdaugherty.github.com/vty-ui/";
    description = "An interactive terminal user interface library for Vty";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
