{ cabal, binary, blazeHtml, citeprocHs, cryptohash, filepath
, hamlet, mtl, pandoc, parsec, regexBase, regexTdfa, snapCore
, snapServer, tagsoup, time
}:

cabal.mkDerivation (self: {
  pname = "hakyll";
  version = "3.2.6.2";
  sha256 = "07l2igpmr4kd47zk88hz2salzzc92dh7wpny6xr5pw5xf95lpx7p";
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
