{ cabal }:

cabal.mkDerivation (self: {
  pname = "regular";
  version = "0.3.4";
  sha256 = "10gfid99xcqv3i9rp4x8hykk91qq3h7b7lxzsl7ii58vmifa4kgq";
  meta = {
    description = "Generic programming library for regular datatypes";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
