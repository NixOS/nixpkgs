{ cabal, mtl, parsec, syb }:

cabal.mkDerivation (self: {
  pname = "preprocessor-tools";
  version = "0.1.3";
  sha256 = "0jz85v93zpv6cwvad18wr12nsikmv4n20gn37zli2h34zi543i9v";
  buildDepends = [ mtl parsec syb ];
  meta = {
    homepage = "http://www.eecs.harvard.edu/~tov/pubs/haskell-session-types/";
    description = "Extending Haskell's syntax using a custom preprocessor";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
