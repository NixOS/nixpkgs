{ cabal }:

cabal.mkDerivation (self: {
  pname = "parallel";
  version = "1.1.0.1";
  sha256 = "0885086660268f3626effacb29a02b5c81f3e5a8dfa99dabe0981ddbc407999f";
  meta = {
    description = "parallel programming library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
