{ cabal, mtl }:

cabal.mkDerivation (self: {
  pname = "fgl";
  version = "5.4.2.4";
  sha256 = "0rh22786f37mpsvhkv075wjh5sd0c83nlhk669xil9rd7swcr66f";
  buildDepends = [ mtl ];
  meta = {
    homepage = "http://web.engr.oregonstate.edu/~erwig/fgl/haskell";
    description = "Martin Erwig's Functional Graph Library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
