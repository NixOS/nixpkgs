{ cabal, mtl, parsec, syb }:

cabal.mkDerivation (self: {
  pname = "json";
  version = "0.6";
  sha256 = "1f5l1992r2gm8fivqfljhgs3nix4qf7h3rji78rsq1kf3r9shz32";
  buildDepends = [ mtl parsec syb ];
  meta = {
    description = "Support for serialising Haskell to and from JSON";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
