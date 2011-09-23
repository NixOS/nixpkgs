{ cabal, shakespeare, text }:

cabal.mkDerivation (self: {
  pname = "shakespeare-text";
  version = "0.10.1";
  sha256 = "1p05nsfmlibhpik6dd40m0djk5yckl4i2ylx9lwyi68lx0izbm5j";
  buildDepends = [ shakespeare text ];
  meta = {
    homepage = "http://www.yesodweb.com/book/templates";
    description = "Interpolation with quasi-quotation: put variables strings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
