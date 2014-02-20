{ cabal, attoparsec }:

cabal.mkDerivation (self: {
  pname = "irc";
  version = "0.6.0.0";
  sha256 = "037hpdb4b6nb5w62w34alwybchzybz0bq2cgp0mv4xlw7bks2nqv";
  buildDepends = [ attoparsec ];
  meta = {
    description = "A small library for parsing IRC messages";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
