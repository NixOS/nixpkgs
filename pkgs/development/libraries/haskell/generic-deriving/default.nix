{ cabal }:

cabal.mkDerivation (self: {
  pname = "generic-deriving";
  version = "1.6.2";
  sha256 = "1ryzg7zgnlhx6mbmpsh4fgqf2d758c94qz2zpg3jxns30hd4sfy6";
  meta = {
    description = "Generic programming library for generalised deriving";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
