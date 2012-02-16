{ cabal, Cabal, filepath, glib, gtk, haddock, mtl, parsec }:

cabal.mkDerivation (self: {
  pname = "ltk";
  version = "0.10.0.4";
  sha256 = "1dp6dl8a0pfj6lx8n8a2y1j3c2z57k9pf81yr45qsp7wg53d6qhf";
  buildDepends = [ Cabal filepath glib gtk haddock mtl parsec ];
  meta = {
    homepage = "http://www.leksah.org";
    description = "Leksah tool kit";
    license = "GPL";
    platforms = self.stdenv.lib.platforms.linux;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
