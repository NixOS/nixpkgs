{ cabal, HUnit, QuickCheck, random }:

cabal.mkDerivation (self: {
  pname = "Crypto";
  version = "4.2.5.1";
  sha256 = "0rmgl0a4k6ys2lc6d607g28c2p443a46dla903rz5aha7m9y1mba";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ HUnit QuickCheck random ];
  meta = {
    description = "Collects together existing Haskell cryptographic functions into a package";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
