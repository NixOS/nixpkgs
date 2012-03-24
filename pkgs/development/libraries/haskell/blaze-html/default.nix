{ cabal, blazeBuilder, text }:

cabal.mkDerivation (self: {
  pname = "blaze-html";
  version = "0.4.3.1";
  sha256 = "0yhwlwmjy3jagxscz2i0yjfy6akqpamn9c35ffxcgpr0kj6qlpfp";
  buildDepends = [ blazeBuilder text ];
  meta = {
    homepage = "http://jaspervdj.be/blaze";
    description = "A blazingly fast HTML combinator library for Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
