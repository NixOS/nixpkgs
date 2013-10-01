{ cabal }:

cabal.mkDerivation (self: {
  pname = "primitive";
  version = "0.5.1.0";
  sha256 = "0a8mf8k62xga5r5dd0fna1swqbx2r94c0mvqnc4mfq640zrsa5w8";
  meta = {
    homepage = "https://github.com/haskell/primitive";
    description = "Primitive memory-related operations";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
