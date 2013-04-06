{ cabal, explicitException, utf8String }:

cabal.mkDerivation (self: {
  pname = "multiarg";
  version = "0.12.0.2";
  sha256 = "0f90dsa5ya55lrc0x0ziz01fjvaq85q4f8zsfci1w1rgxa9m7naa";
  buildDepends = [ explicitException utf8String ];
  meta = {
    homepage = "https://github.com/massysett/multiarg";
    description = "Combinators to build command line parsers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
