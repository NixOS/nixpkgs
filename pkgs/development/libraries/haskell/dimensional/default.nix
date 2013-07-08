{ cabal, numtype, time }:

cabal.mkDerivation (self: {
  pname = "dimensional";
  version = "0.12";
  sha256 = "1bk52wxmgcm34b516npy1ynrzqajgkshd8vfjm44vjcjvfrlf3bc";
  buildDepends = [ numtype time ];
  meta = {
    homepage = "http://dimensional.googlecode.com/";
    description = "Statically checked physical dimensions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
