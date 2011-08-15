{cabal, ghcPaths}:

cabal.mkDerivation (self : {
  pname = "vacuum";
  version = "1.0.0";
  sha256 = "2229948ce801052c5ffb70ffc07e301d87d60740b053df8a7b7851ad02c01d9f";
  propagatedBuildInputs = [ghcPaths];
  meta = {
    homepage = "http://moonpatio.com/vacuum/";
    description = "Extract graph representations of ghc heap values";
    license = "LGPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
