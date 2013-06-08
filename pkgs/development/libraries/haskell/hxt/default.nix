{ cabal, binary, deepseq, filepath, HUnit, hxtCharproperties
, hxtRegexXmlschema, hxtUnicode, mtl, network, parsec
}:

cabal.mkDerivation (self: {
  pname = "hxt";
  version = "9.3.1.1";
  sha256 = "1x0z85vx49s2b9bgjm14c2152cwr0vzf02rlxrla5dj5g565985y";
  buildDepends = [
    binary deepseq filepath HUnit hxtCharproperties hxtRegexXmlschema
    hxtUnicode mtl network parsec
  ];
  jailbreak = true;
  meta = {
    homepage = "http://www.fh-wedel.de/~si/HXmlToolbox/index.html";
    description = "A collection of tools for processing XML with Haskell";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
