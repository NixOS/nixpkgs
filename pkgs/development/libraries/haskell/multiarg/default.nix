{ cabal, explicitException, utf8String }:

cabal.mkDerivation (self: {
  pname = "multiarg";
  version = "0.6.0.0";
  sha256 = "1qrw1rajdvrvd297a7lpfkxm5qqhwmnnl5jiagjwzb9lckgpy87y";
  buildDepends = [ explicitException utf8String ];
  meta = {
    homepage = "https://github.com/massysett/multiarg";
    description = "Combinators to build command line parsers";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
