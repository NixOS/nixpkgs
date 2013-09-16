{ cabal, utf8String }:

cabal.mkDerivation (self: {
  pname = "multiarg";
  version = "0.24.0.0";
  sha256 = "0vdhrsqwa2wq9cvf96x3hqml2vbjcvik9mpz1kbbhb61f9lbhas6";
  buildDepends = [ utf8String ];
  meta = {
    homepage = "https://github.com/massysett/multiarg";
    description = "Combinators to build command line parsers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
