{ cabal, QuickCheck, vector }:

cabal.mkDerivation (self: {
  pname = "repa";
  version = "3.2.3.1";
  sha256 = "0r5z781h9v6ri2m3ih7jbymvc3i2m26qaf29pxwmaks0sdlp4qmr";
  buildDepends = [ QuickCheck vector ];
  jailbreak = true;
  meta = {
    homepage = "http://repa.ouroborus.net";
    description = "High performance, regular, shape polymorphic parallel arrays";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
