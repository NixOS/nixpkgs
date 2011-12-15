{ cabal, binary, deepseq, HUnit, hxtCharproperties
, hxtRegexXmlschema, hxtUnicode, network, parsec
}:

cabal.mkDerivation (self: {
  pname = "hxt";
  version = "9.1.5";
  sha256 = "0w0l86y8q2391dvqn112f2s0infm1zzqnlp9hhwcx8jg2slsxbcm";
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
