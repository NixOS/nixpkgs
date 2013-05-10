{ cabal, filepath, hexpat, hsBibutils, HTTP, json, mtl, network
, pandocTypes, parsec, syb, time, utf8String
}:

cabal.mkDerivation (self: {
  pname = "citeproc-hs";
  version = "0.3.8";
  sha256 = "0wlfwjxg852qcgx54m99xm7hxsmcw8c8r7fyrsxyxl3054xnfwz8";
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
