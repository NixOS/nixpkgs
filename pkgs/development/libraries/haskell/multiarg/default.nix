{ cabal, explicitException, utf8String }:

cabal.mkDerivation (self: {
  pname = "multiarg";
  version = "0.10.0.0";
  sha256 = "09clgin66i2m0b3ws7di9p15cy9bd144as832xpx4li6cfbg16ip";
  buildDepends = [ explicitException utf8String ];
  meta = {
    homepage = "https://github.com/massysett/multiarg";
    description = "Combinators to build command line parsers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
