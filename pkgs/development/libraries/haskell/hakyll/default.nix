{ cabal, binary, blazeHtml, blazeMarkup, citeprocHs, cryptohash
, filepath, hamlet, mtl, pandoc, parsec, regexBase, regexTdfa
, snapCore, snapServer, tagsoup, text, time
}:

cabal.mkDerivation (self: {
  pname = "hakyll";
  version = "3.3.0.0";
  sha256 = "0ljfdmmqigdzg8vaj502vrsz4i6ynaw3vhc9ys24m9xcqdmyha4h";
  buildDepends = [
    binary blazeHtml blazeMarkup citeprocHs cryptohash filepath hamlet
    mtl pandoc parsec regexBase regexTdfa snapCore snapServer tagsoup
    text time
  ];
  meta = {
    homepage = "http://jaspervdj.be/hakyll";
    description = "A static website compiler library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
