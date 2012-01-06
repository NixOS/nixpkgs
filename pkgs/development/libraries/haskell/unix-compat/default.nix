{ cabal }:

cabal.mkDerivation (self: {
  pname = "unix-compat";
  version = "0.3.0.1";
  sha256 = "09y2iih741l4jpi83c15zap94phfms4mavzg04r9rjgbav0ns2c4";
  meta = {
    homepage = "http://github.com/jystic/unix-compat";
    description = "Portable POSIX-compatibility layer";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
