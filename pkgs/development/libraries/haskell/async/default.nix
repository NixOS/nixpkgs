{ cabal, stm }:

cabal.mkDerivation (self: {
  pname = "async";
  version = "2.0.1.1";
  sha256 = "132xr0sb3j02s134my4p7khj95d3v3jlpxqjrgn6h8brw0gp6wcq";
  buildDepends = [ stm ];
  meta = {
    homepage = "https://github.com/simonmar/async";
    description = "Run IO operations asynchronously and wait for their results";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
