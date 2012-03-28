{ cabal, binary, deepseq, filepath, HUnit, hxtCharproperties
, hxtRegexXmlschema, hxtUnicode, mtl, network, parsec
}:

cabal.mkDerivation (self: {
  pname = "hxt";
  version = "9.2.2";
  sha256 = "0ichjpshq10b11dyfv1q7rs2m190x3gplx6k54amlxv45nwd1s6r";
  buildDepends = [
    binary deepseq filepath HUnit hxtCharproperties hxtRegexXmlschema
    hxtUnicode mtl network parsec
  ];
  meta = {
    homepage = "http://www.fh-wedel.de/~si/HXmlToolbox/index.html";
    description = "A collection of tools for processing XML with Haskell";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
