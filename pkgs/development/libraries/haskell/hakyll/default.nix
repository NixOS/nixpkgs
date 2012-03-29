{ cabal, binary, blazeHtml, citeprocHs, cryptohash, filepath
, hamlet, mtl, pandoc, parsec, regexBase, regexTdfa, snapCore
, snapServer, tagsoup, time
}:

cabal.mkDerivation (self: {
  pname = "hakyll";
  version = "3.2.7.0";
  sha256 = "1jx4csfdr7icjrg9hvlw5pyi29qf3yyx0sjaw7nchz8jk43ikr2b";
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
