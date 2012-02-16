{ cabal, binary, blazeHtml, citeprocHs, cryptohash, filepath
, hamlet, mtl, pandoc, parsec, regexBase, regexTdfa, snapCore
, snapServer, tagsoup, time
}:

cabal.mkDerivation (self: {
  pname = "hakyll";
  version = "3.2.6.1";
  sha256 = "0chpg04rsp8lxzdj43wqs3wyc7i70hfi3raxdar6bhwxhfxgj4wn";
  buildDepends = [
    binary blazeHtml citeprocHs cryptohash filepath hamlet mtl pandoc
    parsec regexBase regexTdfa snapCore snapServer tagsoup time
  ];
  meta = {
    homepage = "http://jaspervdj.be/hakyll";
    description = "A static website compiler library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
