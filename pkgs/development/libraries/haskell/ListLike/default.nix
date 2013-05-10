{ cabal }:

cabal.mkDerivation (self: {
  pname = "ListLike";
  version = "3.1.7.1";
  sha256 = "1g3i8iz71x3j41ji9xsbh84v5hj3mxls0zqnx27sb31mx6bic4w1";
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
