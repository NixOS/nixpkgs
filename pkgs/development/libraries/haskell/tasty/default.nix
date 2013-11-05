{ cabal, ansiTerminal, mtl, optparseApplicative, regexPosix, stm
, tagged
}:

cabal.mkDerivation (self: {
  pname = "tasty";
  version = "0.4";
  sha256 = "1gcaam49nm6fx0i2hlf1zih4rxzfgnsl4xiwnqifhz9m15n5laxq";
  buildDepends = [
    ansiTerminal mtl optparseApplicative regexPosix stm tagged
  ];
  meta = {
    description = "Modern and extensible testing framework";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
