{ cabal, mtl, text }:

cabal.mkDerivation (self: {
  pname = "parsec";
  version = "3.1.3";
  sha256 = "1a64gzirgpa1i78gbbp9z059nh29xmcja4g8vgjb1fbylx6vn54z";
  buildDepends = [ mtl text ];
  meta = {
    homepage = "http://www.cs.uu.nl/~daan/parsec.html";
    description = "Monadic parser combinators";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
