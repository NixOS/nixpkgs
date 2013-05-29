{ cabal, blazeBuilder, Cabal, happy, HUnit, mtl, QuickCheck
, testFramework, testFrameworkHunit, utf8Light, utf8String
}:

cabal.mkDerivation (self: {
  pname = "language-javascript";
  version = "0.5.7";
  sha256 = "0mndz0bqxkayzm7g92cvai9ahb9msr99syp9djhaya1d45595ad3";
  buildDepends = [ blazeBuilder mtl utf8Light utf8String ];
  testDepends = [
    blazeBuilder Cabal HUnit mtl QuickCheck testFramework
    testFrameworkHunit utf8Light utf8String
  ];
  buildTools = [ happy ];
  meta = {
    homepage = "http://github.com/alanz/language-javascript";
    description = "Parser for JavaScript";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
