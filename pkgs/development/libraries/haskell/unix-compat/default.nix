{cabal} :

cabal.mkDerivation (self : {
  pname = "unix-compat";
  version = "0.2.2.1";
  sha256 = "009dg6mxjmdkcmr2d1qq9r3f4qfx4d362lyxj9vvgwrzcdnsgzqi";
  meta = {
    homepage = "http://github.com/jystic/unix-compat";
    description = "Portable POSIX-compatibility layer.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.stdenv.lib.platforms.haskellPlatforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
