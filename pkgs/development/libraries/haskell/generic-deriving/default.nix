{ cabal }:

cabal.mkDerivation (self: {
  pname = "generic-deriving";
  version = "1.2.2";
  sha256 = "1k64c3wqvgcvwarv55v8c303l959rs01znq443wynzi7kz7xcfl9";
  meta = {
    description = "Generic programming library for generalised deriving";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
