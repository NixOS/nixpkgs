{ cabal, syb }:

cabal.mkDerivation (self: {
  pname = "hs-bibutils";
  version = "5.0";
  sha256 = "18gchn62g2cqzyj1nr8wd5i6smhq739g00cblkllj1jkni33ch2l";
  buildDepends = [ syb ];
  meta = {
    homepage = "http://gorgias.mine.nu/repos/hs-bibutils/";
    description = "Haskell bindings to bibutils, the bibliography conversion utilities";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
