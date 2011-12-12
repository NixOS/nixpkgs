{ cabal, blazeBuilder, enumerator, httpTypes, network, text
, transformers
}:

cabal.mkDerivation (self: {
  pname = "wai";
  version = "0.4.3";
  sha256 = "08dmsl90ibs6a4sadsd2dhf5mssf5jswk6n2jv19q5sg3dra4m84";
  buildDepends = [
    blazeBuilder enumerator httpTypes network text transformers
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
