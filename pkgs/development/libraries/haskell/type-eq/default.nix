{ cabal, cpphs }:

cabal.mkDerivation (self: {
  pname = "type-eq";
  version = "0.4.1";
  sha256 = "0l8nkrdn1hs8ddhh85qm176f9v42fdck9iscn4swd92vj7bfci7k";
  buildTools = [ cpphs ];
  meta = {
    homepage = "http://github.com/glaebhoerl/type-eq";
    description = "Type equality evidence you can carry around";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
