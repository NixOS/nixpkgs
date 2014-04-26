{ cabal, filemanip, filepath, HUnit, MissingH, testFramework
, testFrameworkHunit, testFrameworkTh, vector
}:

cabal.mkDerivation (self: {
  pname = "tzdata";
  version = "0.1.20140324.0";
  sha256 = "19cw8wag2d5jx9dxia3gr8qjr3bh77a2kp7ksyqp58xxmvmsqdn4";
  buildDepends = [ vector ];
  testDepends = [
    filemanip filepath HUnit MissingH testFramework testFrameworkHunit
    testFrameworkTh
  ];
  meta = {
    homepage = "https://github.com/nilcons/haskell-tzdata";
    description = "Time zone database (as files and as a module)";
    license = self.stdenv.lib.licenses.asl20;
    platforms = self.ghc.meta.platforms;
  };
})
