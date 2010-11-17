{cabal, glib, gtk, haddock, mtl, parsec}:

cabal.mkDerivation (self : {
  pname = "ltk";
  version = "0.8.0.8";
  sha256 = "172l3nvvyqqgzy43b7mjxs8vpfw0wlyl993g77zjiy8qbhlcd9mg";
  propagatedBuildInputs = [glib gtk mtl parsec haddock];
  meta = {
    description = "UI framework used by leksah";
    license = "GPL";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})
