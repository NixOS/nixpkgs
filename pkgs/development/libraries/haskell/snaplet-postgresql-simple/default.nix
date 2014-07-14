{ cabal, clientsession, configurator, errors
, MonadCatchIOTransformers, mtl, postgresqlSimple
, resourcePoolCatchio, snap, text, transformers
, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "snaplet-postgresql-simple";
  version = "0.5";
  sha256 = "0pzn0lg1slrllrrx1n9s1kp1pmq2ahrkjypcwnnld8zxzvz4g5jm";
  buildDepends = [
    clientsession configurator errors MonadCatchIOTransformers mtl
    postgresqlSimple resourcePoolCatchio snap text transformers
    unorderedContainers
  ];
  meta = {
    homepage = "https://github.com/mightybyte/snaplet-postgresql-simple";
    description = "postgresql-simple snaplet for the Snap Framework";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
