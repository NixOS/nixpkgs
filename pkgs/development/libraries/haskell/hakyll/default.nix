{ cabal, binary, blazeHtml, citeprocHs, cryptohash, hamlet, mtl
, pandoc, parsec, regexBase, regexPcre, snapCore, snapServer
, tagsoup, time
}:

cabal.mkDerivation (self: {
  pname = "hakyll";
  version = "3.2.4.0";
  sha256 = "1hyvvcq4hvbwz8zaswi8949sqzjkby6754b0y5zp2cpax2ykkbgx";
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
