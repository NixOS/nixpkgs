{ cabal, blazeBuilder, filepath, hspec, text }:

cabal.mkDerivation (self: {
  pname = "fast-logger";
  version = "2.1.0";
  sha256 = "116xdk455vlgyj3ck3bpzyavbfwq9asj2hlyjazb8vb1f9byxxkf";
  buildDepends = [ blazeBuilder filepath text ];
  testDepends = [ hspec ];
  meta = {
    description = "A fast logging system";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
