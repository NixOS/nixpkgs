{ cabal }:

cabal.mkDerivation (self: {
  pname = "bits-atomic";
  version = "0.1.3";
  sha256 = "13fbakkwcdk63dm7r0mcsanm5mijp73c7x1kxpay2f03rxb39b70";
  isLibrary = true;
  isExecutable = true;
  meta = {
    description = "Atomic bit operations on memory locations for low-level synchronization";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
