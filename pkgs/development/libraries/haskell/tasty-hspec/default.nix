{ cabal, hspec, tasty }:

cabal.mkDerivation (self: {
  pname = "tasty-hspec";
  version = "0.1";
  sha256 = "1pf4ffaqy0f25a2sjirg5g4gdcfslapwq4mm0pkdsysmh9bv1f64";
  buildDepends = [ hspec tasty ];
  meta = {
    homepage = "http://github.com/mitchellwrosen/tasty-hspec";
    description = "Hspec support for the Tasty test framework";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
