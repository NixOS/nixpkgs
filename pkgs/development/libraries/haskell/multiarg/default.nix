{ cabal, utf8String }:

cabal.mkDerivation (self: {
  pname = "multiarg";
  version = "0.22.0.0";
  sha256 = "1fswkgrn8mc92lrzmrxhv6hbgch2lqdvmjn88k4ajqc0gpmpb750";
  buildDepends = [ utf8String ];
  meta = {
    homepage = "https://github.com/massysett/multiarg";
    description = "Combinators to build command line parsers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
