{ cabal, diffutils }:

cabal.mkDerivation (self: {
  pname = "HList";
  version = "0.2.3";
  sha256 = "1efbe0c2cb361ab0a9d864a09f9c58075132cb50094207260cb1363fe73c2908";
  buildTools = [ diffutils ];
  meta = {
    description = "Heterogeneous lists";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
