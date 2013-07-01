{ cabal }:

cabal.mkDerivation (self: {
  pname = "time";
  version = "1.1.2.4";
  sha256 = "11dfcb9b5ca76428a7a31019928c3c1898320f774e5d3df8e4407580d074fad3";
  meta = {
    homepage = "http://semantic.org/TimeLib/";
    description = "A time library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
