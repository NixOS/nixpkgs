{ cabal, colour, extensibleExceptions, fgl, polyparse, transformers
}:

cabal.mkDerivation (self: {
  pname = "graphviz";
  version = "2999.11.0.0";
  sha256 = "1ky8hi9vda8hli7dkvsmmbz9j1swkzsn548905asqz0i46kpspnk";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    colour extensibleExceptions fgl polyparse transformers
  ];
  meta = {
    homepage = "http://projects.haskell.org/graphviz/";
    description = "Graphviz bindings for Haskell.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
