{ cabal, Cabal, hashable, text }:

cabal.mkDerivation (self: {
  pname = "case-insensitive";
  version = "0.4.0.1";
  sha256 = "15wcpzmj1ppl27p8hph9y8nxkjkd4yrvamxi3gk0ahfnb47chaq7";
  buildDepends = [ Cabal hashable text ];
  meta = {
    homepage = "https://github.com/basvandijk/case-insensitive";
    description = "Case insensitive string comparison";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
