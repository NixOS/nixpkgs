{ cabal, HUnit, IORefCAS }:

cabal.mkDerivation (self: {
  pname = "abstract-deque";
  version = "0.1.5";
  sha256 = "1zp19kq3m72nx7rr00yyq8iwia4abg4x9kw4d5s5k0srp5f9fn3q";
  buildDepends = [ HUnit IORefCAS ];
  meta = {
    description = "Abstract, parameterized interface to mutable Deques";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
