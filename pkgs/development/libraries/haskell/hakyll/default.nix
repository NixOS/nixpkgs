{ cabal, binary, blazeHtml, cryptohash, hamlet, mtl, pandoc, parsec
, regexBase, regexPcre, snapCore, snapServer, tagsoup, time
}:

cabal.mkDerivation (self: {
  pname = "hakyll";
  version = "3.2.0.8";
  sha256 = "1yp01g7wzr9qkx3vz7v791gglmr0pg5c6jj076rv118kw0l8n61l";
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
