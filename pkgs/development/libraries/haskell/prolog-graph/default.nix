{ cabal, cmdargs, fgl, graphviz, mtl, prolog, prologGraphLib, text
}:

cabal.mkDerivation (self: {
  pname = "prolog-graph";
  version = "0.1.0.2";
  sha256 = "1w3wz0sn1qhw286g3arin30jvlldadw976xr7hp0afdvqicl3892";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    cmdargs fgl graphviz mtl prolog prologGraphLib text
  ];
  meta = {
    homepage = "https://github.com/Erdwolf/prolog";
    description = "A command line tool to visualize query resolution in Prolog";
    license = self.stdenv.lib.licenses.publicDomain;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
