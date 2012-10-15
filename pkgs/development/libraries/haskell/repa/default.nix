{ cabal, QuickCheck, vector }:

cabal.mkDerivation (self: {
  pname = "repa";
  version = "3.2.2.2";
  sha256 = "1a7rgpy2qc42zc9si7p1zgi1m9b06dz533d2mvhizzac9k3fb5vq";
  buildDepends = [ QuickCheck vector ];
  meta = {
    homepage = "http://repa.ouroborus.net";
    description = "High performance, regular, shape polymorphic parallel arrays";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
