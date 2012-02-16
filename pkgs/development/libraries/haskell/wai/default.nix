{ cabal, blazeBuilder, Cabal, conduit, httpTypes, network, text
, transformers, vault
}:

cabal.mkDerivation (self: {
  pname = "wai";
  version = "1.1.0";
  sha256 = "1kmmivcak9v13rgivs2vhr543dfdx19wncwlpda453570ywam7vh";
  buildDepends = [
    blazeBuilder Cabal conduit httpTypes network text transformers
    vault
  ];
  meta = {
    homepage = "https://github.com/yesodweb/wai";
    description = "Web Application Interface";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
