{ cabal, binary, blazeHtml, blazeMarkup, citeprocHs, cryptohash
, filepath, hamlet, lrucache, mtl, pandoc, parsec, regexBase
, regexTdfa, snapCore, snapServer, tagsoup, text, time
}:

cabal.mkDerivation (self: {
  pname = "hakyll";
  version = "3.5.3.0";
  sha256 = "1r8vz42lxnnxx875jnf0ii9x99g7wz2fmknscxvm40prp2df1z6v";
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
