{ cabal, blazeBuilder, blazeMarkup, text }:

cabal.mkDerivation (self: {
  pname = "blaze-html";
  version = "0.5.0.0";
  sha256 = "0cfvdf50jbm6w277jf69ac57nbkgkn2ifcp6r2amd3qdbmdgqkwj";
  buildDepends = [ blazeBuilder blazeMarkup text ];
  meta = {
    homepage = "http://jaspervdj.be/blaze";
    description = "A blazingly fast HTML combinator library for Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
