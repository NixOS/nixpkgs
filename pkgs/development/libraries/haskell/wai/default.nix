{ cabal, blazeBuilder, conduit, httpTypes, network, text
, transformers, vault
}:

cabal.mkDerivation (self: {
  pname = "wai";
  version = "1.1.0.1";
  sha256 = "0klyi3d4rivgvbasamxccvkz1w44ak0rcbx840ypdcjq8mbcb85f";
  buildDepends = [
    blazeBuilder conduit httpTypes network text transformers vault
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
