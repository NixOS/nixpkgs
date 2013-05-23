{ cabal, network }:

cabal.mkDerivation (self: {
  pname = "network-multicast";
  version = "0.0.7";
  sha256 = "18qlg4cg7ci1z3mbqh5z16mxkjir0079a0rgm4qk6jbmsnvfsq43";
  buildDepends = [ network ];
  meta = {
    description = "Simple multicast library";
    license = self.stdenv.lib.licenses.publicDomain;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
