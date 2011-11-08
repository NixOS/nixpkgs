{ cabal }:

cabal.mkDerivation (self: {
  pname = "cereal";
  version = "0.3.4.0";
  sha256 = "019fc094w2ica9ims83jacy2digbygaww5wb73xyrj3vgjw774xq";
  meta = {
    description = "A binary serialization library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
