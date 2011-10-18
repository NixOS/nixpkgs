{ cabal, binary, blazeHtml, cryptohash, hamlet, mtl, pandoc, parsec
, regexBase, regexPcre, snapCore, snapServer, tagsoup, time
}:

cabal.mkDerivation (self: {
  pname = "hakyll";
  version = "3.2.0.10";
  sha256 = "1hdivw1smfkxza5jl8gm84gnzb5a9sgc2lcas3hikv968p9c1yry";
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
