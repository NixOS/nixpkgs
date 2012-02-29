{ cabal, mtl }:

cabal.mkDerivation (self: {
  pname = "IfElse";
  version = "0.85";
  sha256 = "1kfx1bwfjczj93a8yqz1n8snqiq5655qgzwv1lrycry8wb1vzlwa";
  buildDepends = [ mtl ];
  meta = {
    description = "Anaphoric and miscellaneous useful control-flow";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
