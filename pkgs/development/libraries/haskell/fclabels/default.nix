{ cabal, mtl }:

cabal.mkDerivation (self: {
  pname = "fclabels";
  version = "0.11.2";
  sha256 = "0ish0gy2f3q65c9f4ix0nhcid9kpr7faijxkmwcy9bymjfg441kf";
  buildDepends = [ mtl ];
  meta = {
    description = "First class accessor labels implemented as lenses.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
