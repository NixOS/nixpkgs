{ cabal, blazeBuilder, text }:

cabal.mkDerivation (self: {
  pname = "blaze-html";
  version = "0.4.2.1";
  sha256 = "0hm2jnz9n68njdrrq73a558qxl2jwcvxmy62mvf2v9q96wyp07yj";
  buildDepends = [ blazeBuilder text ];
  meta = {
    homepage = "http://jaspervdj.be/blaze";
    description = "A blazingly fast HTML combinator library for Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
