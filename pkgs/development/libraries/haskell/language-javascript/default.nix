{ cabal, blazeBuilder, Cabal, happy, HUnit, mtl, QuickCheck
, testFramework, testFrameworkHunit, utf8Light, utf8String
}:

cabal.mkDerivation (self: {
  pname = "language-javascript";
  version = "0.5.8";
  sha256 = "0slwj2bi9v7qjr6ai5dwql7fqgsh8k9k2bzlsq407iacsv0w3b9h";
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
