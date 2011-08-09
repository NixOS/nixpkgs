{ cabal, binary, mtl, syb, sybWithClass, sybWithClassInstancesText
, text, time
}:

cabal.mkDerivation (self: {
  pname = "happstack-data";
  version = "6.0.0";
  sha256 = "1wdvylqgy3iw41ksw2ys4f0vyak8sbk6gginljvz07rrh04klyhl";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    binary mtl syb sybWithClass sybWithClassInstancesText text time
  ];
  meta = {
    homepage = "http://happstack.com";
    description = "Happstack data manipulation libraries";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
