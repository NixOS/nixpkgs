{ cabal, doctest, hspec, mtl, parsec }:

cabal.mkDerivation (self: {
  pname = "hsemail";
  version = "1.7.5";
  sha256 = "0ls6y48bndwgb7ng29wxim4h36rs6b07dqi6ic4hqgbb7lg6fma4";
  buildDepends = [ mtl parsec ];
  testDepends = [ doctest hspec parsec ];
  meta = {
    homepage = "http://gitorious.org/hsemail";
    description = "Internet Message Parsers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
