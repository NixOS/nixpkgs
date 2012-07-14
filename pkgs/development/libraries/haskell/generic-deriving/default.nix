{ cabal }:

cabal.mkDerivation (self: {
  pname = "generic-deriving";
  version = "1.2.1";
  sha256 = "0ld4kh3p3lmavxi4y25fpxvq75qk7bd87yvwcbj63j6af1v60h2z";
  meta = {
    description = "Generic programming library for generalised deriving";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
