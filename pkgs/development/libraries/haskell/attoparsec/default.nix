{ cabal, deepseq }:

cabal.mkDerivation (self: {
  pname = "attoparsec";
  version = "0.9.1.1";
  sha256 = "1qkkl9pzk4znqh34pchmxbcslybvii35lkxhwf6445lyhj20356b";
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
