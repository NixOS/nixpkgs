{cabal, hslogger, mtl, network, parsec, unixCompat} :

cabal.mkDerivation (self : {
  pname = "happstack-util";
  version = "6.0.0";
  sha256 = "06qla74kb58q0rvlfa9k16s4crnylq99hm80xx4phlddyzn0cy4z";
  propagatedBuildInputs = [ hslogger mtl network parsec unixCompat ];
  meta = {
    homepage = "http://happstack.com";
    description = "Web framework";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.simons
      self.stdenv.lib.maintainers.andres
    ];
  };
})
