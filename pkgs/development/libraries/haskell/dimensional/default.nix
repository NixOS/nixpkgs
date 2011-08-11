{ cabal, numtype, time }:

cabal.mkDerivation (self: {
  pname = "dimensional";
  version = "0.10";
  sha256 = "5d0ab2a0ca566f7d9a4fe1ec180a1bcf4138a3647a2c287a908506c8911cd385";
  buildDepends = [ numtype time ];
  meta = {
    homepage = "http://dimensional.googlecode.com/";
    description = "Statically checked physical dimensions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
