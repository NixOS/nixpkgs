{ cabal, blazeBuilder, blazeMarkup, text }:

cabal.mkDerivation (self: {
  pname = "blaze-html";
  version = "0.5.1.2";
  sha256 = "1lzv7s6b5hv4ja1134gjj8h5ygckhlnfb02vp5c29mbnqjpdwk5a";
  buildDepends = [ blazeBuilder blazeMarkup text ];
  meta = {
    homepage = "http://jaspervdj.be/blaze";
    description = "A blazingly fast HTML combinator library for Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
