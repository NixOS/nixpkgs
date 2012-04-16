{ cabal, binary, blazeHtml, citeprocHs, cryptohash, filepath
, hamlet, mtl, pandoc, parsec, regexBase, regexTdfa, snapCore
, snapServer, tagsoup, time
}:

cabal.mkDerivation (self: {
  pname = "hakyll";
  version = "3.2.7.2";
  sha256 = "1l37w3q2jhcxjkq3h0nh8hl21vscgvsj6jkkd2hni62kfzfrgqhw";
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
