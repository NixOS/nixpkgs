{ cabal, blazeBuilder, text, time, vector }:

cabal.mkDerivation (self: {
  pname = "blaze-textual-native";
  version = "0.2.1";
  sha256 = "12cnl76qld19x6zlhxcsx2b27mfr9v7sc2xq6af9h77wqb98fkvn";
  buildDepends = [ blazeBuilder text time vector ];
  meta = {
    homepage = "http://github.com/mailrank/blaze-textual";
    description = "Fast rendering of common datatypes";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
