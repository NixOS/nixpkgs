{ cabal, alex, blazeBuilder, Cabal, happy, HUnit, mtl, QuickCheck
, testFramework, testFrameworkHunit, utf8Light, utf8String
}:

cabal.mkDerivation (self: {
  pname = "language-javascript";
  version = "0.5.12";
  sha256 = "1zzgjxqgfl6k2z4cwh0961ipfc5fminfdg2162g45h2nrv63mq05";
  buildDepends = [ blazeBuilder mtl utf8String ];
  testDepends = [
    blazeBuilder Cabal HUnit mtl QuickCheck testFramework
    testFrameworkHunit utf8Light utf8String
  ];
  buildTools = [ alex happy ];
  meta = {
    homepage = "http://github.com/alanz/language-javascript";
    description = "Parser for JavaScript";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
