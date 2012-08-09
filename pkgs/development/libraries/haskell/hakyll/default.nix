{ cabal, binary, blazeHtml, blazeMarkup, citeprocHs, cryptohash
, filepath, hamlet, mtl, pandoc, parsec, regexBase, regexTdfa
, snapCore, snapServer, tagsoup, text, time
}:

cabal.mkDerivation (self: {
  pname = "hakyll";
  version = "3.4.0.0";
  sha256 = "1m69kzjbsspf69qc3yq6qhpnk3vd3k5qa7zssazm8717sgrb2z9m";
  buildDepends = [
    binary blazeHtml blazeMarkup citeprocHs cryptohash filepath hamlet
    mtl pandoc parsec regexBase regexTdfa snapCore snapServer tagsoup
    text time
  ];
  patchPhase = ''
    sed -i hakyll.cabal -e 's|hamlet.*,|hamlet,|'
  '';
  meta = {
    homepage = "http://jaspervdj.be/hakyll";
    description = "A static website compiler library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
