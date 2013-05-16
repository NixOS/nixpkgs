{ cabal, syb }:

cabal.mkDerivation (self: {
  pname = "hs-bibutils";
  version = "4.17.1";
  sha256 = "0qn3kibwwiaandmk672n9lki431934qahj81r4yj2acmyv6fcycf";
  buildDepends = [ syb ];
  meta = {
    homepage = "http://gorgias.mine.nu/repos/hs-bibutils/";
    description = "Haskell bindings to bibutils, the bibliography conversion utilities";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
