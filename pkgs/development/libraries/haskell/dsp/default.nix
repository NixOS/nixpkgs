{ cabal, random }:

cabal.mkDerivation (self: {
  pname = "dsp";
  version = "0.2.3";
  sha256 = "1h7y3b2gwbkq97lv6f9a4zssyqs422g5zj2bi9mq1a5fzy5i4v4v";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ random ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/DSP";
    description = "Haskell Digital Signal Processing";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
  };
})
