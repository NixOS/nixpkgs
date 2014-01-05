{ cabal, HUnit, mtl, tasty }:

cabal.mkDerivation (self: {
  pname = "tasty-hunit";
  version = "0.4.1";
  sha256 = "1ns4lbqjkgfgl00jg4sw2jz3r189z4k5fzwbii3g1bnskn28fapa";
  buildDepends = [ HUnit mtl tasty ];
  meta = {
    description = "HUnit support for the Tasty test framework";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
