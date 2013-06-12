{ cabal, QuickCheck, storableRecord }:

cabal.mkDerivation (self: {
  pname = "sample-frame";
  version = "0.0.2";
  sha256 = "1k1fyslgw5vvn9a38mhp7c9j1xxf75ys010rcn2vr3pm6aj868sx";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ QuickCheck storableRecord ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Synthesizer";
    description = "Handling of samples in an (audio) signal";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
