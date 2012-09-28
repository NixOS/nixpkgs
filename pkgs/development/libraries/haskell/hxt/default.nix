{ cabal, binary, deepseq, filepath, HUnit, hxtCharproperties
, hxtRegexXmlschema, hxtUnicode, mtl, network, parsec
}:

cabal.mkDerivation (self: {
  pname = "hxt";
  version = "9.3.1.0";
  sha256 = "0nv7d7ffwq81671c7gyzaqx7xgrgs42svbq5xraij4jbq5406719";
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
