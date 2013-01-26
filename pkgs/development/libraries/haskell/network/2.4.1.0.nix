{ cabal, parsec }:

cabal.mkDerivation (self: {
  pname = "network";
  version = "2.4.1.0";
  sha256 = "0m44iqlcnpsaa3iqxb4wbx2l1k2ycxzq8v07bwz7br7yyikv16y3";
  buildDepends = [ parsec ];
  meta = {
    homepage = "https://github.com/haskell/network";
    description = "Low-level networking interface";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
