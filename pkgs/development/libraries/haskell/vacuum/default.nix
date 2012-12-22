{ cabal, ghcPaths }:

cabal.mkDerivation (self: {
  pname = "vacuum";
  version = "2.1.0.1";
  sha256 = "0gzh5v9mr0mgz9hxjnm8n3jcl2702wad7qaqaar1zc95lkabpf65";
  extraLibraries = [ ghcPaths ];
  meta = {
    homepage = "http://thoughtpolice.github.com/vacuum";
    description = "Graph representation of the GHC heap";
    license = self.stdenv.lib.licenses.gpl3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
