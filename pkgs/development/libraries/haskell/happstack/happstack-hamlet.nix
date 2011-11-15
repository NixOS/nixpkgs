{ cabal, hamlet, happstackServer, text }:

cabal.mkDerivation (self: {
  pname = "happstack-hamlet";
  version = "6.2.1";
  sha256 = "1ypw3lcrbkfkk8k45642kmgj0wjwz7vi3szslii6dirycg99jwkv";
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
