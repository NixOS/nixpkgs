{cabal, blazeBuilder, text} :

cabal.mkDerivation (self : {
  pname = "blaze-html";
  version = "0.4.1.6";
  sha256 = "084phxxdy12vi2q084k8w693m94v0pjf29zx2fk1y0n80k05ii4z";
  propagatedBuildInputs = [ blazeBuilder text ];
  meta = {
    homepage = "http://jaspervdj.be/blaze";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.simons
      self.stdenv.lib.maintainers.andres
    ];
  };
})
