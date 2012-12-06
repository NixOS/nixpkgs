{ cabal, blazeBuilder, text }:

cabal.mkDerivation (self: {
  pname = "blaze-markup";
  version = "0.5.1.3";
  sha256 = "138d1p4a8y6fs3ilkv2y9dmv9m0czjgan0n27qvmn7pzpj9fxd50";
  buildDepends = [ blazeBuilder text ];
  meta = {
    homepage = "http://jaspervdj.be/blaze";
    description = "A blazingly fast markup combinator library for Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
