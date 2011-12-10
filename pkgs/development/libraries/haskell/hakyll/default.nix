{ cabal, binary, blazeHtml, citeprocHs, cryptohash, hamlet, mtl
, pandoc, parsec, regexBase, regexPcre, snapCore, snapServer
, tagsoup, time
}:

cabal.mkDerivation (self: {
  pname = "hakyll";
  version = "3.2.3.2";
  sha256 = "0410gg8sdnw0iyhqrw1wfv9abbrv7r6awgvlhqds17vnrdxxk2w8";
  buildDepends = [
    binary blazeHtml citeprocHs cryptohash hamlet mtl pandoc parsec
    regexBase regexPcre snapCore snapServer tagsoup time
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
