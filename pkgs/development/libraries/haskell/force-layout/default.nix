{ cabal, dataDefaultClass, lens, vectorSpace, vectorSpacePoints }:

cabal.mkDerivation (self: {
  pname = "force-layout";
  version = "0.3.0.4";
  sha256 = "1zgqcz9b86qax1hyl32a1giapvn2wpnb4gcfn8czkcr0m7c2iwdg";
  buildDepends = [
    dataDefaultClass lens vectorSpace vectorSpacePoints
  ];
  meta = {
    description = "Simple force-directed layout";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
