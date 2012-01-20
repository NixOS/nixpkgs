{ cabal, binary, blazeHtml, citeprocHs, cryptohash, hamlet, mtl
, pandoc, parsec, regexBase, regexPcre, snapCore, snapServer
, tagsoup, time
}:

cabal.mkDerivation (self: {
  pname = "hakyll";
  version = "3.2.4.1";
  sha256 = "0ijym3k8f9za6cd1dnf8qx0jk85r5kz4f8gy7bn50jclcslnfl0n";
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
