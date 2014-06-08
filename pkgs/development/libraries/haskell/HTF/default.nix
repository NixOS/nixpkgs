{ cabal, aeson, cpphs, Diff, filepath, haskellSrcExts, HUnit
, liftedBase, monadControl, mtl, QuickCheck, random, regexCompat
, temporary, text, unorderedContainers, xmlgen
}:

cabal.mkDerivation (self: {
  pname = "HTF";
  version = "0.11.3.4";
  sha256 = "0db47fvp33k83dnhvpygprm06p3z397f5ci154vqk7krjpxb2ynx";
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
  doCheck = false;
  meta = {
    homepage = "https://github.com/skogsbaer/HTF/";
    description = "The Haskell Test Framework";
    license = "LGPL";
    platforms = self.ghc.meta.platforms;
  };
})
