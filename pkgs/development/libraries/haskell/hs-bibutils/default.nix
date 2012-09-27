{ cabal, syb }:

cabal.mkDerivation (self: {
  pname = "hs-bibutils";
  version = "4.14";
  sha256 = "1icdaayahwgfmckd93k26kic2wdgyl65lv08rnwydsi5vlqww32x";
  buildDepends = [ syb ];
  meta = {
    homepage = "http://gorgias.mine.nu/repos/hs-bibutils/";
    description = "Haskell bindings to bibutils, the bibliography conversion utilities";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
