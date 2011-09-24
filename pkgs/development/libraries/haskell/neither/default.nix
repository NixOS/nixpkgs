{ cabal, failure, transformers }:

cabal.mkDerivation (self: {
  pname = "neither";
  version = "0.3.0";
  sha256 = "0lak4y0k4cisr27vw2bnpd0pa1kkgv8r96z7vf19wg7brzarx71l";
  buildDepends = [ failure transformers ];
  meta = {
    homepage = "http://github.com/snoyberg/neither";
    description = "Provide versions of Either with good monad and applicative instances";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
