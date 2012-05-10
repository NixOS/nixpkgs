{ cabal }:

cabal.mkDerivation (self: {
  pname = "xhtml";
  version = "3000.2.1";
  sha256 = "17qzc6kyiilhi8s25k68fbpyplihb1qxkpc6l93bvjrcchilsf22";
  meta = {
    homepage = "https://github.com/haskell/xhtml";
    description = "An XHTML combinator library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
