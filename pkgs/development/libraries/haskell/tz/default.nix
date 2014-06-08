{ cabal, binary, bindingsPosix, deepseq, HUnit, pkgs_tzdata
, QuickCheck, testFramework, testFrameworkHunit
, testFrameworkQuickcheck2, testFrameworkTh, time, tzdata, vector
}:

cabal.mkDerivation (self: {
  pname = "tz";
  version = "0.0.0.5";
  sha256 = "03s5vs08dj3r7rq78ncya6x6dazvr93gfylyynwybpai09l2y89v";
  buildDepends = [ binary deepseq time tzdata vector ];
  testDepends = [
    bindingsPosix HUnit QuickCheck testFramework testFrameworkHunit
    testFrameworkQuickcheck2 testFrameworkTh time tzdata
  ];
  preConfigure = "export TZDIR=${pkgs_tzdata}/share/zoneinfo";
  meta = {
    homepage = "https://github.com/nilcons/haskell-tz";
    description = "Efficient time zone handling";
    license = self.stdenv.lib.licenses.asl20;
    platforms = self.ghc.meta.platforms;
  };
})
