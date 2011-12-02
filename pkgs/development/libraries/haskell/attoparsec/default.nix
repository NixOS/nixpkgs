{ cabal, deepseq, text }:

cabal.mkDerivation (self: {
  pname = "attoparsec";
  version = "0.10.0.3";
  sha256 = "0qlmjv8fhbx0xk8vkhlm01qmqlbk7xl98vfhcnlcjjrc5wkj0pjc";
  buildDepends = [ deepseq text ];
  meta = {
    homepage = "https://github.com/bos/attoparsec";
    description = "Fast combinator parsing for bytestrings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
