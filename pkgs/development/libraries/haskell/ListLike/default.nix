{ cabal }:

cabal.mkDerivation (self: {
  pname = "ListLike";
  version = "3.1.6";
  sha256 = "0ij6yb80dv841zn23lp6251avzmljzmy4j25r7w6h55y32y7gq46";
  isLibrary = true;
  isExecutable = true;
  meta = {
    homepage = "http://software.complete.org/listlike";
    description = "Generic support for list-like structures";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
