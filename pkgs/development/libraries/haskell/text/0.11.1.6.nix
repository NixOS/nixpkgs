{ cabal, deepseq }:

cabal.mkDerivation (self: {
  pname = "text";
  version = "0.11.1.6";
  sha256 = "1c4vzxwjcmdlb8nj71g6rqdw4nhz0l17saazhw1vv8cbizmdm4m7";
  buildDepends = [ deepseq ];
  meta = {
    homepage = "https://github.com/bos/text";
    description = "An efficient packed Unicode text type";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
