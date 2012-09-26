{ cabal, blazeBuilder, blazeMarkup, text }:

cabal.mkDerivation (self: {
  pname = "blaze-html";
  version = "0.5.1.0";
  sha256 = "1f256z68pbm1h6wsk33p94byxwfp01i4pbdrch32jdi1q35cmqxh";
  buildDepends = [ blazeBuilder blazeMarkup text ];
  meta = {
    homepage = "http://jaspervdj.be/blaze";
    description = "A blazingly fast HTML combinator library for Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
