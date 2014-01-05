{ cabal, acidState, snap, text }:

cabal.mkDerivation (self: {
  pname = "snaplet-acid-state";
  version = "0.2.6";
  sha256 = "005c4x7sh820iar69rany3hv4rlbzpsd4yqd2x2v3jql9z55k4s9";
  buildDepends = [ acidState snap text ];
  meta = {
    homepage = "https://github.com/mightybyte/snaplet-acid-state";
    description = "acid-state snaplet for Snap Framework";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
