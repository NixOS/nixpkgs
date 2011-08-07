{cabal, X11} :

cabal.mkDerivation (self : {
  pname = "HGL";
  version = "3.2.0.2";
  sha256 = "13wcvf6bfii9pihr8m08b81fyslf5n587ds4zzgizbd8m38k81vz";
  propagatedBuildInputs = [ X11 ];
  meta = {
    description = "A simple graphics library based on X11 or Win32";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.stdenv.lib.platforms.haskellPlatforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
