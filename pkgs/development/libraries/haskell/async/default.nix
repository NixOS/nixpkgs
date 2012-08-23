{ cabal, stm }:

cabal.mkDerivation (self: {
  pname = "async";
  version = "2.0.1.2";
  sha256 = "03mmrs1xrw91pv9xpas8acxvrh4j6bq5l24bqk4vmaq2pdy9snn3";
  buildDepends = [ stm ];
  meta = {
    homepage = "https://github.com/simonmar/async";
    description = "Run IO operations asynchronously and wait for their results";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
