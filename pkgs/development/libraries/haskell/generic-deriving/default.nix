{ cabal }:

cabal.mkDerivation (self: {
  pname = "generic-deriving";
  version = "1.4.0";
  sha256 = "15av3l4m4qn5by41rkpdvp1kyp3fi9ixvy76wmyj20c46kjbmra7";
  meta = {
    description = "Generic programming library for generalised deriving";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
