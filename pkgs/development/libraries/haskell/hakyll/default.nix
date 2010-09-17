{cabal, binary, hamlet, mtl, network, pandoc, regexBase, regexTDFA, time}:

cabal.mkDerivation (self : {
  pname = "hakyll";
  version = "2.3";
  sha256 = "40e57c5cf5be3c6fdc270d00ff765a2b3e11ba7e302f40146d83048aa4436116";
  propagatedBuildInputs = [hamlet mtl network pandoc regexBase regexTDFA time];
  meta = {
    description = "A simple static site generator library";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})
