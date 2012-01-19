{ cabal, blazeBuilder, text, time, vector }:

cabal.mkDerivation (self: {
  pname = "blaze-textual-native";
  version = "0.2.1.1";
  sha256 = "1q3gdf4ljc5xhw8f72qkvi6insk2nwdfk28a00y1b58jmk8003sd";
  buildDepends = [ blazeBuilder text time vector ];
  meta = {
    homepage = "http://github.com/mailrank/blaze-textual";
    description = "Fast rendering of common datatypes (deprecated)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
