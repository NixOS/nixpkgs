{ cabal, binary, blazeHtml, blazeMarkup, citeprocHs, cryptohash
, filepath, hamlet, lrucache, mtl, pandoc, parsec, regexBase
, regexTdfa, snapCore, snapServer, tagsoup, text, time
}:

cabal.mkDerivation (self: {
  pname = "hakyll";
  version = "3.5.0.0";
  sha256 = "18mvnhhf03qq2zr85vyg3h87kf2ny0jrj0zjp0886i6qvmbrjwlj";
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
