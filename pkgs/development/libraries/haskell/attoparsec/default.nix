{ cabal, deepseq, text }:

cabal.mkDerivation (self: {
  pname = "attoparsec";
  version = "0.10.1.0";
  sha256 = "1wlil4zxnyrygvkgmap8kcqf4f6rc08ais20alyy4ggzmx73sl9q";
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
