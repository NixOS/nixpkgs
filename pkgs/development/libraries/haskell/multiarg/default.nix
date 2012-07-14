{ cabal, explicitException, utf8String }:

cabal.mkDerivation (self: {
  pname = "multiarg";
  version = "0.4.0.0";
  sha256 = "04m4ynf6x8rlnlmnl6a7jj42fszjc1bly4h3jyjxxsqjdynrv81q";
  buildDepends = [ explicitException utf8String ];
  meta = {
    homepage = "https://github.com/massysett/multiarg";
    description = "Combinators to build command line parsers";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
