{ cabal, stm }:

cabal.mkDerivation (self: {
  pname = "monad-loops";
  version = "0.3.3.0";
  sha256 = "06v8wnkbjrpsy47shjy2bd8asbw6d5rgzy8z5q0jwdhira42h3v1";
  buildDepends = [ stm ];
  meta = {
    homepage = "https://github.com/mokus0/monad-loops";
    description = "Monadic loops";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
