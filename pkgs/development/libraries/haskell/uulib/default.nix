{ cabal }:

cabal.mkDerivation (self: {
  pname = "uulib";
  version = "0.9.15";
  sha256 = "0433shh493c04qmi0sd9mfzpy198zi11gxdmcs6nz2gcnxm812zm";
  meta = {
    homepage = "http://www.cs.uu.nl/wiki/HUT/WebHome";
    description = "Haskell Utrecht Tools Library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
