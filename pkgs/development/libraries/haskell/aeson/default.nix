{cabal, attoparsec, blazeBuilder, blazeTextual, deepseq, hashable,
 mtl, syb, text, unorderedContainers, vector} :

cabal.mkDerivation (self : {
  pname = "aeson";
  version = "0.3.2.9";
  sha256 = "1qaajk797zpickw4ik5lc03wnmxkrcmv3zik7n1bjqx6h37h0zqw";
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
