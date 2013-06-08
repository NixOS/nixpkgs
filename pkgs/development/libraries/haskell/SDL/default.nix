{ cabal, SDL }:

cabal.mkDerivation (self: {
  pname = "SDL";
  version = "0.6.4";
  sha256 = "1zrfx2nw0k8lfkr6vnwsp5wr3yz62v0bq60p4sdzj7gm01bz92g0";
  extraLibraries = [ SDL ];
  meta = {
    description = "Binding to libSDL";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
