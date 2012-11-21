{ cabal, digestiveFunctors, filepath, mtl, snapCore, text }:

cabal.mkDerivation (self: {
  pname = "digestive-functors-snap";
  version = "0.5.0.2";
  sha256 = "0xx5i09l8n1srdmslq0sq1h366cdq3xqxwjd3kp2ck9s6x65zyjz";
  buildDepends = [ digestiveFunctors filepath mtl snapCore text ];
  meta = {
    homepage = "http://github.com/jaspervdj/digestive-functors";
    description = "Snap backend for the digestive-functors library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
