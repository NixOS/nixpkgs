{ cabal, Cabal }:

cabal.mkDerivation (self: {
  pname = "logfloat";
  version = "0.12.1";
  sha256 = "1k13jjqv4df341hcj9hzrlisfx9wrsmyqvzi6ricx341d9z4ch05";
  buildDepends = [ Cabal ];
  meta = {
    homepage = "http://code.haskell.org/~wren/";
    description = "Log-domain floating point numbers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
