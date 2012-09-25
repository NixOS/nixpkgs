{ cabal, parsec }:

cabal.mkDerivation (self: {
  pname = "network";
  version = "2.4.0.1";
  sha256 = "00jj3pf2gchkx5wmipm2ijxcmhy37g86ggnp6pb92i5nmb93h1iw";
  buildDepends = [ parsec ];
  meta = {
    homepage = "https://github.com/haskell/network";
    description = "Low-level networking interface";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
