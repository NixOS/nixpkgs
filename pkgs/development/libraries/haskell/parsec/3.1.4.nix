{ cabal, mtl, text }:

cabal.mkDerivation (self: {
  pname = "parsec";
  version = "3.1.4";
  sha256 = "0milmi4q5jdcmmwjqa4lcs1vcw5frkrlrxc8q17lkas3p2m10kh5";
  buildDepends = [ mtl text ];
  meta = {
    homepage = "http://www.cs.uu.nl/~daan/parsec.html";
    description = "Monadic parser combinators";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
