{ cabal, binary, blazeHtml, blazeMarkup, citeprocHs, cryptohash
, filepath, hamlet, lrucache, mtl, pandoc, parsec, regexBase
, regexTdfa, snapCore, snapServer, tagsoup, text, time
}:

cabal.mkDerivation (self: {
  pname = "hakyll";
  version = "3.5.1.0";
  sha256 = "16aaxnknxbpzdlm6dlmsq8pfssp63ywqim0zm3kvf7zic3hvq2xr";
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
