{ cabal }:

cabal.mkDerivation (self: {
  pname = "multirec";
  version = "0.7.4";
  sha256 = "01mligrin7fp3fnnwgv8nrww5938ryghgyw9xyw153a615ryj8i9";
  meta = {
    homepage = "http://www.cs.uu.nl/wiki/GenericProgramming/Multirec";
    description = "Generic programming for families of recursive datatypes";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
