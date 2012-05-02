{ cabal, explicitException, text, transformers, utf8String }:

cabal.mkDerivation (self: {
  pname = "multiarg";
  version = "0.2.0.0";
  sha256 = "1jmhlh4ngmkddrkcafx0qcmzwbmi5crkmd6p8b07cfjpaq2pc6yx";
  buildDepends = [ explicitException text transformers utf8String ];
  meta = {
    homepage = "https://github.com/massysett/multiarg";
    description = "Combinators to build command line parsers";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
