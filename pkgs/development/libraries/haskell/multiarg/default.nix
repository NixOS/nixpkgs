{ cabal, utf8String }:

cabal.mkDerivation (self: {
  pname = "multiarg";
  version = "0.24.0.4";
  sha256 = "1f572046hlv2yngqa4bcxc4kwi8sc5q7v2dw2aap6pv7jfm8m8ws";
  buildDepends = [ utf8String ];
  meta = {
    homepage = "https://github.com/massysett/multiarg";
    description = "Combinators to build command line parsers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
