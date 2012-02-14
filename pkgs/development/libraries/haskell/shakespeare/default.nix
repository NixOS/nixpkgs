{ cabal, Cabal, parsec, text }:

cabal.mkDerivation (self: {
  pname = "shakespeare";
  version = "0.10.3.1";
  sha256 = "1wfw5qbgl4jl1r4gaw55mnsmn70vpzn7ykz3gbqzrf91wc6s3zj4";
  buildDepends = [ Cabal parsec text ];
  meta = {
    homepage = "http://www.yesodweb.com/book/templates";
    description = "A toolkit for making compile-time interpolated templates";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
