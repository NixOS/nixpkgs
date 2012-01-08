{ cabal, ListLike, MonadCatchIOTransformers, parallel, transformers
}:

cabal.mkDerivation (self: {
  pname = "iteratee";
  version = "0.8.7.6";
  sha256 = "05zhw44zycwllvyrkxz1mkn5mkylrdz9ynh27k17gsm9mjml3cab";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    ListLike MonadCatchIOTransformers parallel transformers
  ];
  meta = {
    homepage = "http://www.tiresiaspress.us/haskell/iteratee";
    description = "Iteratee-based I/O";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
