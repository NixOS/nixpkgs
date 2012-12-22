{ cabal, attoparsec }:

cabal.mkDerivation (self: {
  pname = "http-date";
  version = "0.0.3";
  sha256 = "12iylfzz1d0v0gl4cf31dxcmlg0x7bq5f7acacy2pb0ilrxmzsnn";
  buildDepends = [ attoparsec ];
  meta = {
    description = "HTTP Date parser/formatter";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
