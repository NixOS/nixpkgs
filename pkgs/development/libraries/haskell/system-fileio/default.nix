{ cabal, systemFilepath, text, time }:

cabal.mkDerivation (self: {
  pname = "system-fileio";
  version = "0.3.9";
  sha256 = "0mfmijwnkp92s58jb51lk0p1p3418f6qskr95phc1zp40yrcw8nx";
  buildDepends = [ systemFilepath text time ];
  meta = {
    homepage = "https://john-millikin.com/software/haskell-filesystem/";
    description = "Consistent filesystem interaction across GHC versions";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
