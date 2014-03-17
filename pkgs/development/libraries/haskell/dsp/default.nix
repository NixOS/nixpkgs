{ cabal, random }:

cabal.mkDerivation (self: {
  pname = "dsp";
  version = "0.2.2";
  sha256 = "0vb71z8iky3xl40b9d79z7krq960ykcgn3y8lks3wzgiabbh2d89";
  buildDepends = [ random ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/DSP";
    description = "Haskell Digital Signal Processing";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
  };
})
