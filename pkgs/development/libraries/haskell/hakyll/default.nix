{ cabal, binary, blazeHtml, cryptohash, hamlet, mtl, pandoc, parsec
, regexBase, regexPcre, snapCore, snapServer, tagsoup, time
}:

cabal.mkDerivation (self: {
  pname = "hakyll";
  version = "3.2.0.9";
  sha256 = "1gb10bvzlm8qn6ap7cxykscbhbs2jsfqgsw53r8vd8k5bfgm5jv6";
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
