{ cabal, Cabal, X11 }:

cabal.mkDerivation (self: {
  pname = "HGL";
  version = "3.2.0.2";
  sha256 = "13wcvf6bfii9pihr8m08b81fyslf5n587ds4zzgizbd8m38k81vz";
  buildDepends = [ Cabal X11 ];
  meta = {
    description = "A simple graphics library based on X11 or Win32";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
