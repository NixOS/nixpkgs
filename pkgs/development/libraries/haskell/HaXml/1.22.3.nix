{cabal, polyparse}:

cabal.mkDerivation (self : {
  pname = "HaXml";
  version = "1.22.3";
  sha256 = "10gbax7nih45ck5fg056gnfgzr7zyndxpvdhvx3af2wnrmilkcbh";
  propagatedBuildInputs = [polyparse];
  meta = {
    description = "Haskell utilities for parsing, filtering, transforming and generating XML documents.";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})

