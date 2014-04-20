{ cabal, deepseq, hashable, smallcheck, tasty, tastySmallcheck
, text
}:

cabal.mkDerivation (self: {
  pname = "scientific";
  version = "0.2.0.2";
  sha256 = "13rrdaf5mrhpckq9vvrm4pnj63vahg7f0g75hk11nk7k1644l4f0";
  buildDepends = [ deepseq hashable text ];
  testDepends = [ smallcheck tasty tastySmallcheck text ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/basvandijk/scientific";
    description = "Arbitrary-precision floating-point numbers represented using scientific notation";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
