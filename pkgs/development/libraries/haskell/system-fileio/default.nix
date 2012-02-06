{ cabal, systemFilepath, text, time }:

cabal.mkDerivation (self: {
  pname = "system-fileio";
  version = "0.3.4";
  sha256 = "184f5bb3qhag6cwmk0zc2ldkwnkzbv82pv7hy541j8jqqi5wprih";
  buildDepends = [ systemFilepath text time ];
  meta = {
    homepage = "https://john-millikin.com/software/haskell-filesystem/";
    description = "Consistent filesystem interaction across GHC versions";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
