{ cabal, text }:

cabal.mkDerivation (self: {
  pname = "system-filepath";
  version = "0.4.2";
  sha256 = "070srsvqqjix0afy5ch1zcmpnrrszkds83rv0dp0izqrlzl038mr";
  buildDepends = [ text ];
  meta = {
    homepage = "https://john-millikin.com/software/hs-filepath/";
    description = "High-level, byte-based file and directory path manipulations";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
