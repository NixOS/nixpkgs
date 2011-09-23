{ cabal, hamlet, happstackServer, text }:

cabal.mkDerivation (self: {
  pname = "happstack-hamlet";
  version = "6.2.0";
  sha256 = "1y3nc6z9y96fci25dc6w66l0qlnkz29kr29dpd2sjnhpqm0kvzsc";
  buildDepends = [ hamlet happstackServer text ];
  meta = {
    homepage = "http://www.happstack.com/";
    description = "Support for Hamlet HTML templates in Happstack";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
