{ cabal, primitive, vector }:

cabal.mkDerivation (self: {
  pname = "vector-algorithms";
  version = "0.4";
  sha256 = "04ig2bx3gm42mwhcz5n8kp9sy33d1hrwm940kfxny74fc06422h8";
  buildDepends = [ primitive vector ];
  meta = {
    homepage = "http://code.haskell.org/~dolio/";
    description = "Efficient algorithms for vector arrays";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
