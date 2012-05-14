{ cabal, blazeBuilder, text }:

cabal.mkDerivation (self: {
  pname = "blaze-html";
  version = "0.4.3.4";
  sha256 = "1xd8l28rriczd5zxgmjif393kjzqibrp68pfah0kknrjmc3ybn20";
  buildDepends = [ blazeBuilder text ];
  meta = {
    homepage = "http://jaspervdj.be/blaze";
    description = "A blazingly fast HTML combinator library for Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
