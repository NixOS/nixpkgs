{ cabal, binary, deepseq, HUnit, hxtCharproperties
, hxtRegexXmlschema, hxtUnicode, network, parsec
}:

cabal.mkDerivation (self: {
  pname = "hxt";
  version = "9.1.6";
  sha256 = "1ir1az8zpi9adkwpm3m4gjrwrn9cbmwd1dbqz4lrwi82i54c9bpb";
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
