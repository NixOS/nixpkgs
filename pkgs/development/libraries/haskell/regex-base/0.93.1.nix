{ cabal, Cabal, mtl }:

cabal.mkDerivation (self: {
  pname = "regex-base";
  version = "0.93.1";
  sha256 = "24a0e76ab308517a53d2525e18744d9058835626ed4005599ecd8dd4e07f3bef";
  buildDepends = [ Cabal mtl ];
  meta = {
    homepage = "http://sourceforge.net/projects/lazy-regex";
    description = "Replaces/Enhances Text.Regex";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
