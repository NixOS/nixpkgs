{ cabal, syb }:

cabal.mkDerivation (self: {
  pname = "hs-bibutils";
  version = "4.17";
  sha256 = "0vv1qsxbwwb1nfwpvxvqacfjs3sswldrx3wimaxixmw9ynkkkwdg";
  buildDepends = [ syb ];
  meta = {
    homepage = "http://gorgias.mine.nu/repos/hs-bibutils/";
    description = "Haskell bindings to bibutils, the bibliography conversion utilities";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
