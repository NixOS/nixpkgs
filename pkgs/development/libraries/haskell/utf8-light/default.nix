{ cabal }:

cabal.mkDerivation (self: {
  pname = "utf8-light";
  version = "0.4.0.1";
  sha256 = "1y2vfxjgq8r90bpaxhha0s837vklpwdj4cj3h61bimc0lcx22905";
  meta = {
    description = "Unicode";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
