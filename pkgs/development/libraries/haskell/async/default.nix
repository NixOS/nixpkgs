{ cabal, stm }:

cabal.mkDerivation (self: {
  pname = "async";
  version = "2.0.1.3";
  sha256 = "1rbjr6xw5sp8npw17fxg0942kikssv2hyci2sy26r0na98483mkh";
  buildDepends = [ stm ];
  meta = {
    homepage = "https://github.com/simonmar/async";
    description = "Run IO operations asynchronously and wait for their results";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
