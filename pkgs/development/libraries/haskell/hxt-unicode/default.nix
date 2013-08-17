{ cabal, hxtCharproperties }:

cabal.mkDerivation (self: {
  pname = "hxt-unicode";
  version = "9.0.2.1";
  sha256 = "1ng3qaiwkaav1kmf0yxkm44887xphbx6slva3fskzx0sgkd1v0vp";
  buildDepends = [ hxtCharproperties ];
  meta = {
    homepage = "http://www.fh-wedel.de/~si/HXmlToolbox/index.html";
    description = "Unicode en-/decoding functions for utf8, iso-latin-* and other encodings";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
