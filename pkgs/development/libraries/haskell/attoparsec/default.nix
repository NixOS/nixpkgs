{ cabal, deepseq }:

cabal.mkDerivation (self: {
  pname = "attoparsec";
  version = "0.9.1.2";
  sha256 = "0h9j4gn376k6j3v9l6pk7a4vxabkwk80043x6xlyxsh8p77jgj3v";
  buildDepends = [ deepseq ];
  meta = {
    homepage = "https://bitbucket.org/bos/attoparsec";
    description = "Fast combinator parsing for bytestrings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
