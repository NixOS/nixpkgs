{ cabal, blazeBuilder, Cabal, happy, HUnit, mtl, QuickCheck
, testFramework, testFrameworkHunit, utf8Light, utf8String, alex
}:

cabal.mkDerivation (self: {
  pname = "language-javascript";
  version = "0.5.9";
  sha256 = "1m1fs2vaw3yn9ryd49aprxc5l10xkr86mlxxf5bk6qp51wnp9xqh";
  buildDepends = [ blazeBuilder mtl utf8Light utf8String ];
  testDepends = [
    blazeBuilder Cabal HUnit mtl QuickCheck testFramework
    testFrameworkHunit utf8Light utf8String
  ];
  buildTools = [ happy alex ];
  preConfigure = "rm -rv dist; $SHELL runalex.sh";
  meta = {
    homepage = "http://github.com/alanz/language-javascript";
    description = "Parser for JavaScript";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
