{ cabal, text }:

cabal.mkDerivation (self: {
  pname = "double-conversion";
  version = "0.2.0.1";
  sha256 = "146ijcv55k0lqlw8y4nz7p5kjpwry2jzbqmkan904pnlcfv4a60a";
  buildDepends = [ text ];
  meta = {
    homepage = "https://github.com/mailrank/double-conversion";
    description = "Fast conversion between double precision floating point and text";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
