{ cabal, binary, blazeHtml, cryptohash, hamlet, mtl, pandoc, parsec
, regexBase, regexPcre, snapCore, snapServer, tagsoup, time
}:

cabal.mkDerivation (self: {
  pname = "hakyll";
  version = "3.2.0.7";
  sha256 = "1p06596yfsa0lk5ipdxm1b8j81aph2k30pm2g6ghw6k7fglklyl5";
  buildDepends = [
    binary blazeHtml cryptohash hamlet mtl pandoc parsec regexBase
    regexPcre snapCore snapServer tagsoup time
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
