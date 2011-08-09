{ cabal }:

cabal.mkDerivation (self: {
  pname = "clientsession";
  version = "0.6.0";
  sha256 = "0h92jjkhldn7f9b78cajfda8rprsj5scdsyl3pjpzicpvvy9g00y";
  isLibrary = true;
  isExecutable = true;
  meta = {
    homepage = "http://github.com/snoyberg/clientsession/tree/master";
    description = "Store session data in a cookie.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
