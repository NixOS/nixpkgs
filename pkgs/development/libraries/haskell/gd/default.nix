{ cabal, expat, fontconfig, freetype, gd, libjpeg, libpng, zlib }:

cabal.mkDerivation (self: {
  pname = "gd";
  version = "3000.7.3";
  sha256 = "1dkzv6zs00qi0jmblkw05ywizc8y3baz7pnz0lcqn1cs1mhcpbhl";
  extraLibraries = [
    expat fontconfig freetype gd libjpeg libpng zlib
  ];
  meta = {
    description = "A Haskell binding to a subset of the GD graphics library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
