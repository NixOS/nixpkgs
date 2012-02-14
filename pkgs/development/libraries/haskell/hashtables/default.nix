{ cabal, Cabal, hashable, primitive, vector }:

cabal.mkDerivation (self: {
  pname = "hashtables";
  version = "1.0.1.2";
  sha256 = "09lviwxwlhvhrgm7v66w0vd7j02s0191w1izsvwh1a3dj2vc7vw7";
  buildDepends = [ Cabal hashable primitive vector ];
  meta = {
    homepage = "http://github.com/gregorycollins/hashtables";
    description = "Mutable hash tables in the ST monad";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
