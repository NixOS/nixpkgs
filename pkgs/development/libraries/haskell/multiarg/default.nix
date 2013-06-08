{ cabal, explicitException, utf8String }:

cabal.mkDerivation (self: {
  pname = "multiarg";
  version = "0.16.0.0";
  sha256 = "086mnhbp1d3n0xdn4cdlyrkkgrykg4bwhi7sbfdmn688qhpl3g9m";
  buildDepends = [ explicitException utf8String ];
  meta = {
    homepage = "https://github.com/massysett/multiarg";
    description = "Combinators to build command line parsers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
