{ cabal, Cabal, deepseq, text }:

cabal.mkDerivation (self: {
  pname = "attoparsec";
  version = "0.10.1.1";
  sha256 = "07zl85nkimpswlb4rxycisaphhyrlq4la2limxxi7sk21gyh88b0";
  buildDepends = [ Cabal deepseq text ];
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
