{ cabal, filepath, hexpat, hsBibutils, HTTP, json, mtl, network
, pandocTypes, parsec, syb, time, utf8String
}:

cabal.mkDerivation (self: {
  pname = "citeproc-hs";
  version = "0.3.7";
  sha256 = "0ix9y7z8m8x4l10h96fgv820grywvwcp3019wxjja4y4w6irid3b";
  buildDepends = [
    filepath hexpat hsBibutils HTTP json mtl network pandocTypes parsec
    syb time utf8String
  ];
  meta = {
    homepage = "http://gorgias.mine.nu/repos/citeproc-hs/";
    description = "A Citation Style Language implementation in Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
