{ cabal }:

cabal.mkDerivation (self: {
  pname = "type-eq";
  version = "0.3";
  sha256 = "094m8mk4a1iiqgrnqw0yk89rimp5ffj7i4n61nx3lzxqs5mw0kws";
  meta = {
    homepage = "http://github.com/glehel/type-eq";
    description = "Type equality evidence you can carry around";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
