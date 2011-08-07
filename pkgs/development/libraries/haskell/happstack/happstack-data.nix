{cabal, binary, mtl, syb, sybWithClass, sybWithClassInstancesText,
 text} :

cabal.mkDerivation (self : {
  pname = "happstack-data";
  version = "6.0.0";
  sha256 = "1wdvylqgy3iw41ksw2ys4f0vyak8sbk6gginljvz07rrh04klyhl";
  propagatedBuildInputs = [
    binary mtl syb sybWithClass sybWithClassInstancesText text
  ];
  meta = {
    homepage = "http://happstack.com";
    description = "Happstack data manipulation libraries";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.stdenv.lib.platforms.haskellPlatforms;
    maintainers = [
      self.stdenv.lib.maintainers.simons
      self.stdenv.lib.maintainers.andres
    ];
  };
})
