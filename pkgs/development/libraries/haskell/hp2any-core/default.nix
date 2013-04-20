{ cabal, attoparsec, filepath, network, time }:

cabal.mkDerivation (self: {
  pname = "hp2any-core";
  version = "0.11.2";
  sha256 = "1gmw9bggw8hsp6pi0xgrryf0sqjb1aaxbwh85q5h72h4ixskwn1y";
  buildDepends = [ attoparsec filepath network time ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Hp2any";
    description = "Heap profiling helper library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
