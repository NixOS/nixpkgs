{ cabal, hxtCharproperties }:

cabal.mkDerivation (self: {
  pname = "hxt-unicode";
  version = "9.0.1";
  sha256 = "0g8qz7waip7zsdi35idj9db6qd7lqbv88l0c4rz8q7nh85jsp6ym";
  buildDepends = [ hxtCharproperties ];
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
