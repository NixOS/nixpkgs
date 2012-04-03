{ cabal, binary, blazeHtml, citeprocHs, cryptohash, filepath
, hamlet, mtl, pandoc, parsec, regexBase, regexTdfa, snapCore
, snapServer, tagsoup, time
}:

cabal.mkDerivation (self: {
  pname = "hakyll";
  version = "3.2.7.1";
  sha256 = "07d7a8l2phb787wgqyh1rci1v9hzwxw35arg03hkal072sacif0c";
  buildDepends = [
    binary blazeHtml citeprocHs cryptohash filepath hamlet mtl pandoc
    parsec regexBase regexTdfa snapCore snapServer tagsoup time
  ];
  meta = {
    homepage = "http://jaspervdj.be/hakyll";
    description = "A static website compiler library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
