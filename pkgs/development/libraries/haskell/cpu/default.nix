{ cabal }:

cabal.mkDerivation (self: {
  pname = "cpu";
  version = "0.1.2";
  sha256 = "0x19mlanmkg96h6h1i04w2i631z84y4rbk22ki4zhgsajysgw9sn";
  isLibrary = true;
  isExecutable = true;
  meta = {
    homepage = "http://github.com/vincenthz/hs-cpu";
    description = "Cpu information and properties helpers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
