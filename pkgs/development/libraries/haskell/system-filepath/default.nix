{ cabal, deepseq, text }:

cabal.mkDerivation (self: {
  pname = "system-filepath";
  version = "0.4.4";
  sha256 = "16904xwbcy82ghf1bckw8h63pfj9jfbdlqrr8jf91jzl27lqlwxf";
  buildDepends = [ deepseq text ];
  meta = {
    homepage = "https://john-millikin.com/software/haskell-filesystem/";
    description = "High-level, byte-based file and directory path manipulations";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
