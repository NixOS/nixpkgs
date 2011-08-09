{ cabal, text }:

cabal.mkDerivation (self: {
  pname = "hashable";
  version = "1.1.2.1";
  sha256 = "1kmx3jr9cmkbapd7gywx7zvyd22nyz2mgs8lnzspp5hi7crx3wcx";
  buildDepends = [ text ];
  meta = {
    homepage = "http://github.com/tibbe/hashable";
    description = "A class for types that can be converted to a hash value";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
