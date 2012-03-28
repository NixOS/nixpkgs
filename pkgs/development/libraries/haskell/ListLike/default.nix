{ cabal }:

cabal.mkDerivation (self: {
  pname = "ListLike";
  version = "3.1.4";
  sha256 = "0cpj7vqlazs2yzh0ffhlg69kdb18xyicybfw614nlqfhhrp53lj9";
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
