{ cabal, parsec }:

cabal.mkDerivation (self: {
  pname = "network";
  version = "2.2.1.7";
  sha256 = "0e65b28a60764245c1ab6661a3566f286feb36e0e6f0296d6cd2b84adcd45d58";
  buildDepends = [ parsec ];
  meta = {
    description = "Networking-related facilities";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
