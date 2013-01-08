{ cabal, binary, blazeHtml, blazeMarkup, citeprocHs, cryptohash
, filepath, hamlet, lrucache, mtl, pandoc, parsec, regexBase
, regexTdfa, snapCore, snapServer, tagsoup, text, time
}:

cabal.mkDerivation (self: {
  pname = "hakyll";
  version = "3.5.2.1";
  sha256 = "1fp7jak2sfznvg3lfyjqy13m1iq9821mdq6n5qmqz5dh5b960iv4";
  buildDepends = [
    binary blazeHtml blazeMarkup citeprocHs cryptohash filepath hamlet
    lrucache mtl pandoc parsec regexBase regexTdfa snapCore snapServer
    tagsoup text time
  ];
  meta = {
    homepage = "http://jaspervdj.be/hakyll";
    description = "A static website compiler library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
