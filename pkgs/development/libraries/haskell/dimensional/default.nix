{ cabal, numtype, time }:

cabal.mkDerivation (self: {
  pname = "dimensional";
  version = "0.12.2";
  sha256 = "0b5w9g3xn74b7z4bcsfcijnj54r8cwbbd8129q61c3nhng1f896a";
  buildDepends = [ numtype time ];
  meta = {
    homepage = "http://dimensional.googlecode.com/";
    description = "Statically checked physical dimensions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
