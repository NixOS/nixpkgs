{ cabal, blazeBuilder, doubleConversion, text, time, vector }:

cabal.mkDerivation (self: {
  pname = "blaze-textual";
  version = "0.2.0.4";
  sha256 = "0bifxyzm35xvlqry06iv6pqgx1d33jnrvpmn4wnydkyg1r7q3k9v";
  buildDepends = [ blazeBuilder doubleConversion text time vector ];
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
