{ cabal, binary, blazeHtml, citeprocHs, cryptohash, hamlet, mtl
, pandoc, parsec, regexBase, regexPcre, snapCore, snapServer
, tagsoup, time
}:

cabal.mkDerivation (self: {
  pname = "hakyll";
  version = "3.2.3.0";
  sha256 = "15s66sr6y7k01yy01411r38hg1vyyv7yqaj8s44n5qzl0yln9gq8";
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
