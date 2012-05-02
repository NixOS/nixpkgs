{ cabal }:

cabal.mkDerivation (self: {
  pname = "semigroups";
  version = "0.8.3";
  sha256 = "179m5vvhf8rf01fnq8b2lg7v8i70yx6yq975jiazghm0qnsm32ji";
  meta = {
    homepage = "http://github.com/ekmett/semigroups/";
    description = "Haskell 98 semigroups";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
