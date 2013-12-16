{ cabal, fclabels, hashable, hashtables, unorderedContainers }:

cabal.mkDerivation (self: {
  pname = "accelerate";
  version = "0.14.0.0";
  sha256 = "0b6mnv5l2vrbljak2yx9akpsyqc0qg1il54w0rlfm29fgqknlhjh";
  buildDepends = [
    fclabels hashable hashtables unorderedContainers
  ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/AccelerateHS/accelerate/";
    description = "An embedded language for accelerated array processing";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
