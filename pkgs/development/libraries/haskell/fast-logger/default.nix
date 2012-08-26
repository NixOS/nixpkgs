{ cabal, blazeBuilder, filepath, text, unixTime }:

cabal.mkDerivation (self: {
  pname = "fast-logger";
  version = "0.2.2";
  sha256 = "1r1fk0lqmh49v24wnx236x9cz122c8806y9mrxnaihxggw4anj0x";
  buildDepends = [ blazeBuilder filepath text unixTime ];
  meta = {
    description = "A fast logging system";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
