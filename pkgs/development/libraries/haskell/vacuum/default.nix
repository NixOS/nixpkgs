{ cabal, ghcPaths }:

cabal.mkDerivation (self: {
  pname = "vacuum";
  version = "2.0.0.0";
  sha256 = "0a810ql4lp1pyvys9a5aw28gxn7h2p4hkc0by4pmpw5d7kdhn9y3";
  extraLibraries = [ ghcPaths ];
  meta = {
    homepage = "http://thoughtpolice.github.com/vacuum";
    description = "Graph representation of the GHC heap";
    license = self.stdenv.lib.licenses.gpl3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
