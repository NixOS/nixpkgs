{ cabal, blazeBuilder, text }:

cabal.mkDerivation (self: {
  pname = "blaze-html";
  version = "0.4.2.0";
  sha256 = "098y9mzq6jr73lavv7ky58bl3aajvdg72y12varpf3v3rr4l0lb2";
  buildDepends = [ blazeBuilder text ];
  meta = {
    homepage = "http://jaspervdj.be/blaze";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
