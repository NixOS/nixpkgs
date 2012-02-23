{ cabal, SDL }:

cabal.mkDerivation (self: {
  pname = "SDL";
  version = "0.6.3";
  sha256 = "0m3ick3rw8623ja42yfj4pa57naa6yb20ym8lv252gwb18ghp4sp";
  extraLibraries = [ SDL ];
  meta = {
    description = "Binding to libSDL";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
