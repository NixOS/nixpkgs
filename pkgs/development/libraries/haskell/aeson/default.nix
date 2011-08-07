{cabal, attoparsec, blazeBuilder, blazeTextual, deepseq, hashable,
 mtl, syb, text, unorderedContainers, vector} :

cabal.mkDerivation (self : {
  pname = "aeson";
  version = "0.3.2.10";
  sha256 = "003bd6nyayd7rd9j4ncjgv7kvsncv4sb84yskqjwiq7y0b36shj8";
  propagatedBuildInputs = [
    attoparsec blazeBuilder blazeTextual deepseq hashable mtl syb text
    unorderedContainers vector
  ];
  meta = {
    homepage = "http://github.com/mailrank/aeson";
    description = "Fast JSON parsing and encoding";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.stdenv.lib.platforms.haskellPlatforms;
    maintainers = [
      self.stdenv.lib.maintainers.simons
      self.stdenv.lib.maintainers.andres
    ];
  };
})
