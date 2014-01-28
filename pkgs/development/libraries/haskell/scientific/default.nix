{ cabal, deepseq, hashable, smallcheck, tasty, tastySmallcheck
, text
}:

cabal.mkDerivation (self: {
  pname = "scientific";
  version = "0.2.0.1";
  sha256 = "0xwxds884pqywjbc4j6qkx27nbi64sihig8ps9v884sk08021wrp";
  buildDepends = [ deepseq hashable text ];
  testDepends = [ smallcheck tasty tastySmallcheck text ];
  meta = {
    homepage = "https://github.com/basvandijk/scientific";
    description = "Arbitrary-precision floating-point numbers represented using scientific notation";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
