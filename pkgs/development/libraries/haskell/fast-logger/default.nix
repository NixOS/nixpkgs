{ cabal, blazeBuilder, filepath, text, unixTime }:

cabal.mkDerivation (self: {
  pname = "fast-logger";
  version = "0.2.1";
  sha256 = "12avan85dkwipp8hqsya8yslirykz2yvqmns3wjhwl9j30idj7r3";
  buildDepends = [ blazeBuilder filepath text unixTime ];
  meta = {
    description = "A fast logging system";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
