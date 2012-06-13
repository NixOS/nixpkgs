{ cabal, stm }:

cabal.mkDerivation (self: {
  pname = "async";
  version = "2.0.0.0";
  sha256 = "03aqgfgpar53k7bzb3s988a4fg0pzy7jmjv299wz2hxl7vr6fzkr";
  buildDepends = [ stm ];
  meta = {
    homepage = "https://github.com/simonmar/async";
    description = "Run IO operations asynchronously and wait for their results";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
