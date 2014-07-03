{ cabal, aeson, base64Bytestring, cpphs, Diff, filepath
, haskellSrcExts, HUnit, liftedBase, monadControl, mtl, QuickCheck
, random, regexCompat, temporary, text, unorderedContainers, xmlgen
}:

cabal.mkDerivation (self: {
  pname = "HTF";
  version = "0.11.4.0";
  sha256 = "0bg84x6xk359zby04xw62yy227fk85mgs7x5nkdbsxcajm7j0bs9";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson base64Bytestring cpphs Diff haskellSrcExts HUnit liftedBase
    monadControl mtl QuickCheck random regexCompat text xmlgen
  ];
  testDepends = [
    aeson filepath mtl random regexCompat temporary text
    unorderedContainers
  ];
  doCheck = false;
  meta = {
    homepage = "https://github.com/skogsbaer/HTF/";
    description = "The Haskell Test Framework";
    license = "LGPL";
    platforms = self.ghc.meta.platforms;
  };
})
