{ cabal, text }:

cabal.mkDerivation (self: {
  pname = "wl-pprint-text";
  version = "1.0.0.0";
  sha256 = "1zvjsbn98g0lja2jj00d7mvqjq4rik7v7wsy5655wibmy0hbll90";
  buildDepends = [ text ];
  meta = {
    description = "A Wadler/Leijen Pretty Printer for Text values";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
