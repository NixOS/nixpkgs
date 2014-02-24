{ cabal, utf8String }:

cabal.mkDerivation (self: {
  pname = "multiarg";
  version = "0.24.0.2";
  sha256 = "0jqkqw0v9dzby6cm0ijj1ff5dpps8hbjnhrscf2qwja9x974686s";
  buildDepends = [ utf8String ];
  meta = {
    homepage = "https://github.com/massysett/multiarg";
    description = "Combinators to build command line parsers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
