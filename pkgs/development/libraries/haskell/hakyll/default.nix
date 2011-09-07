{ cabal, binary, blazeHtml, cryptohash, hamlet, mtl, pandoc, parsec
, regexBase, regexPcre, snapCore, snapServer, tagsoup, time
}:

cabal.mkDerivation (self: {
  pname = "hakyll";
  version = "3.2.0.6";
  sha256 = "11jdajciswswv9ciyd6hk7qc39l09y9s528vazxq0k6z5mwvwrbp";
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
