{ cabal }:

cabal.mkDerivation (self: {
  pname = "ListLike";
  version = "3.1.5";
  sha256 = "0hxpjmj5qdyb55wda2bgd3crkg9q6dklhj2kff7qz6wkx5fdbvjs";
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
