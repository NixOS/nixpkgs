{ cabal, doctest, hspec, lens, taggy, text, unorderedContainers }:

cabal.mkDerivation (self: {
  pname = "taggy-lens";
  version = "0.1.1";
  sha256 = "1c4xp8h47vxcy6lvldb73185z26fmgsjakml9b3zjnlfjihgl6kz";
  buildDepends = [ lens taggy text unorderedContainers ];
  testDepends = [
    doctest hspec lens taggy text unorderedContainers
  ];
  meta = {
    homepage = "http://github.com/alpmestan/taggy-lens";
    description = "Lenses for the taggy html/xml parser";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
