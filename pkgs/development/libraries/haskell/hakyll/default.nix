{ cabal, binary, blazeHtml, blazeMarkup, citeprocHs, cryptohash
, filepath, hamlet, lrucache, mtl, pandoc, parsec, regexBase
, regexTdfa, snapCore, snapServer, tagsoup, text, time
}:

cabal.mkDerivation (self: {
  pname = "hakyll";
  version = "3.4.2.0";
  sha256 = "18yqbiw75wjzc48s5v2aisdc5w2q1rkijxa5p4f4i17flif72j2n";
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
