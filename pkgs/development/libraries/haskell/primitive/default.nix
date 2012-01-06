{ cabal }:

cabal.mkDerivation (self: {
  pname = "primitive";
  version = "0.4.0.1";
  sha256 = "08j7js5y2vk3ywfhs260fxngd725xkvhrp20dcwb67fk8qgxh4bz";
  meta = {
    homepage = "http://code.haskell.org/primitive";
    description = "Wrappers for primitive operations";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
