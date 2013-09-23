{ cabal, acidState, snap, text }:

cabal.mkDerivation (self: {
  pname = "snaplet-acid-state";
  version = "0.2.5";
  sha256 = "0qx6as1m0fwb5fkhvl0k71kx65njwq0dk183xi4gmdzhf83hkjbs";
  buildDepends = [ acidState snap text ];
  meta = {
    homepage = "https://github.com/mightybyte/snaplet-acid-state";
    description = "acid-state snaplet for Snap Framework";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
