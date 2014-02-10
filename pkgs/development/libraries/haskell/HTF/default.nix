{ cabal, aeson, cpphs, Diff, filepath, haskellSrcExts, HUnit
, liftedBase, monadControl, mtl, QuickCheck, random, regexCompat
, temporary, text, unorderedContainers, xmlgen
}:

cabal.mkDerivation (self: {
  pname = "HTF";
  version = "0.11.2";
  sha256 = "12q7j1vhb5w8lnpnxn1aszs4bv2yigi3php6pimcwwv9q9vc3i3c";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson cpphs Diff haskellSrcExts HUnit liftedBase monadControl mtl
    QuickCheck random regexCompat text xmlgen
  ];
  testDepends = [
    aeson filepath mtl random regexCompat temporary text
    unorderedContainers
  ];
  meta = {
    homepage = "https://github.com/skogsbaer/HTF/";
    description = "The Haskell Test Framework";
    license = "LGPL";
    platforms = self.ghc.meta.platforms;
  };
})
