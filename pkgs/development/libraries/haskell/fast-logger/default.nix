{ cabal, blazeBuilder, filepath, hspec, text }:

cabal.mkDerivation (self: {
  pname = "fast-logger";
  version = "2.1.5";
  sha256 = "12f7yad2f6q846rw2ji5fsx3d7qd8jdrnnzsbji5bpv00mvvsiza";
  buildDepends = [ blazeBuilder filepath text ];
  testDepends = [ hspec ];
  meta = {
    description = "A fast logging system";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
