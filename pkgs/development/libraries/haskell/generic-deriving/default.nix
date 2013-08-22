{ cabal }:

cabal.mkDerivation (self: {
  pname = "generic-deriving";
  version = "1.6.1";
  sha256 = "0c3b3xkjdfp14w48gfk3f6aqz4cgk6i3bl5mci23mbb3f33jcx1j";
  meta = {
    description = "Generic programming library for generalised deriving";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
