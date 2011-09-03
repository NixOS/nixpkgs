{ cabal, binary, deepseq, HUnit, hxtCharproperties
, hxtRegexXmlschema, hxtUnicode, network, parsec
}:

cabal.mkDerivation (self: {
  pname = "hxt";
  version = "9.1.4";
  sha256 = "1dqnxb1dikw74l02sb6q193ipk9qfwqlgvcd362705mdqzai124c";
  buildDepends = [
    binary deepseq HUnit hxtCharproperties hxtRegexXmlschema hxtUnicode
    network parsec
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
