{ cabal }:

cabal.mkDerivation (self: {
  pname = "tagged";
  version = "0.7";
  sha256 = "1g78hl6sib1mhg016gy3fqw78x72jsgqizsgim8a1pysjzq0y6zm";
  meta = {
    homepage = "http://github.com/ekmett/tagged";
    description = "Haskell 98 phantom types to avoid unsafely passing dummy arguments";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
