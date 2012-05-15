{ cabal, HUnit, QuickCheck, random }:

cabal.mkDerivation (self: {
  pname = "Crypto";
  version = "4.2.5";
  sha256 = "0wv48is2jqia8hda6q65y3mhabxlw9hjzmpk3dx70rzh4w44yxb8";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ HUnit QuickCheck random ];
  meta = {
    description = "Collects together existing Haskell cryptographic functions into a package";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
