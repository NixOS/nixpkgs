{ cabal, binary, Cabal, deepseq, filepath, HUnit, hxtCharproperties
, hxtRegexXmlschema, hxtUnicode, mtl, network, parsec
}:

cabal.mkDerivation (self: {
  pname = "hxt";
  version = "9.2.0";
  sha256 = "182yl4ksh4hg332b0lnk4s9cfqxsnnan7p5vqas5lbxvibmg68zc";
  buildDepends = [
    binary Cabal deepseq filepath HUnit hxtCharproperties
    hxtRegexXmlschema hxtUnicode mtl network parsec
  ];
  meta = {
    homepage = "http://www.fh-wedel.de/~si/HXmlToolbox/index.html";
    description = "A collection of tools for processing XML with Haskell";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
