{ cabal }:

cabal.mkDerivation (self: {
  pname = "monad-loops";
  version = "0.4.2";
  sha256 = "08sz08p4z1p78dv7rmsqvin59h19i6i07sp7jg3zwxwjxa76fds8";
  meta = {
    homepage = "https://github.com/mokus0/monad-loops";
    description = "Monadic loops";
    license = self.stdenv.lib.licenses.publicDomain;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
