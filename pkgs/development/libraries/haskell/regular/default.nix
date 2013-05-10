{ cabal }:

cabal.mkDerivation (self: {
  pname = "regular";
  version = "0.3.4.2";
  sha256 = "0fshjpbgabdcsa9a4cjmvfrzy7db4s679rprdbrhhfwf5xiszs2s";
  meta = {
    description = "Generic programming library for regular datatypes";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
