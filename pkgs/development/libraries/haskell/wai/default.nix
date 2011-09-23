{ cabal, blazeBuilder, enumerator, httpTypes, network, text
, transformers
}:

cabal.mkDerivation (self: {
  pname = "wai";
  version = "0.4.2";
  sha256 = "18w4wzryyqcqqihwckbz92smkqhhxh3lmi0kgxkcgivyzvhd2jqy";
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
