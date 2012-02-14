{ cabal, Cabal, hxtCharproperties }:

cabal.mkDerivation (self: {
  pname = "hxt-unicode";
  version = "9.0.2";
  sha256 = "1ri3198j0bavgam861yiiisl43rh4pbkmji7g6v3jnnch7834hdd";
  buildDepends = [ Cabal hxtCharproperties ];
  meta = {
    homepage = "http://www.fh-wedel.de/~si/HXmlToolbox/index.html";
    description = "Unicode en-/decoding functions for utf8, iso-latin-* and other encodings";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
