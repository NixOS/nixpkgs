{ cabal, syb, utf8String }:

cabal.mkDerivation (self: {
  pname = "HsSyck";
  version = "0.50";
  sha256 = "0ap675i2fngvd1nw1dk8p2fz4nbd2aq5ci8dsvpcjbp28y9j2blm";
  buildDepends = [ syb utf8String ];
  meta = {
    description = "Fast, lightweight YAML loader and dumper";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
