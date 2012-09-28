{ cabal, syb }:

cabal.mkDerivation (self: {
  pname = "hs-bibutils";
  version = "4.15";
  sha256 = "1h2vqi6ymhx9wpfv5qzvq4fhc4iand93shsncp8nszk64acmz9z9";
  buildDepends = [ syb ];
  meta = {
    homepage = "http://gorgias.mine.nu/repos/hs-bibutils/";
    description = "Haskell bindings to bibutils, the bibliography conversion utilities";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
