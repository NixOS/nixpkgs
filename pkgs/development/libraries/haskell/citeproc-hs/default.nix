{ cabal, filepath, hsBibutils, HTTP, json, mtl, network
, pandocTypes, parsec, syb, time, utf8String, xml
}:

cabal.mkDerivation (self: {
  pname = "citeproc-hs";
  version = "0.3.5";
  sha256 = "134sdz22h2aqwy3cmn0vw91nmbp3ckpjg5djxsg93ddl08ahr4zr";
  buildDepends = [
    filepath hsBibutils HTTP json mtl network pandocTypes parsec syb
    time utf8String xml
  ];
  meta = {
    homepage = "http://gorgias.mine.nu/repos/citeproc-hs/";
    description = "A Citation Style Language implementation in Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
