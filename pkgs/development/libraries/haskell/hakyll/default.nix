{cabal, binary, blazeHtml, hamlet, hopenssl, mtl, pandoc, parsec,
 regexBase, regexPcre, snapCore, snapServer, tagsoup} :

cabal.mkDerivation (self : {
  pname = "hakyll";
  version = "3.2.0.5";
  sha256 = "1rwmdkzwshhi6b27zff42gg65vds866l68h33p4kn6pq1rns3bz4";
  propagatedBuildInputs = [
    binary blazeHtml hamlet hopenssl mtl pandoc parsec regexBase
    regexPcre snapCore snapServer tagsoup
  ];
  meta = {
    homepage = "http://jaspervdj.be/hakyll";
    description = "A static website compiler library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.simons
      self.stdenv.lib.maintainers.andres
    ];
  };
})
