{ cabal, mtl }:

cabal.mkDerivation (self: {
  pname = "unlambda";
  version = "0.1";
  sha256 = "0xmn5w5vza6z2i3fs2hv2jgmb1lyk918viknsx3lk36i1dbyivgi";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ mtl ];
  meta = {
    description = "Unlambda interpreter";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
