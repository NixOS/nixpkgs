{ cabal, deepseq, hashable, QuickCheck, smallcheck, tasty
, tastyAntXml, tastyQuickcheck, tastySmallcheck, text
}:

cabal.mkDerivation (self: {
  pname = "scientific";
  version = "0.3.2.1";
  sha256 = "0z0k0dqmv6a3spgl48yl00a55niv0gqjy906sh4r8xfpsabzl88s";
  buildDepends = [ deepseq hashable text ];
  testDepends = [
    QuickCheck smallcheck tasty tastyAntXml tastyQuickcheck
    tastySmallcheck text
  ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/basvandijk/scientific";
    description = "Numbers represented using scientific notation";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
