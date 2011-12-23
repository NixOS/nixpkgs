{ cabal, deepseq }:

cabal.mkDerivation (self: {
  pname = "text";
  version = "0.11.1.11";
  sha256 = "0k58f6p3lnr3dh9d7n39lydqk3rkfsyds2jgwpi0zwml20bdaqcl";
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
