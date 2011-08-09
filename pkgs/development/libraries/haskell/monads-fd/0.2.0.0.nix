{cabal, mtl, transformers} :

cabal.mkDerivation (self : {
  pname = "monads-fd";
  version = "0.2.0.0";
  sha256 = "1iqr5p3va5sxmpvydwqz2src54j5njcyrzn9p5apc60nv7yv6x4c";
  propagatedBuildInputs = [ mtl transformers ];
  meta = {
    description = "Monad classes, using functional dependencies";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.simons
      self.stdenv.lib.maintainers.andres
    ];
  };
})
