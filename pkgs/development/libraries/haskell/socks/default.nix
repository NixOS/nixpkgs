{ cabal, cereal, network }:

cabal.mkDerivation (self: {
  pname = "socks";
  version = "0.4.2";
  sha256 = "1nbhx2jjij5kjqa0l68s401ach4yziq6w8mvcv589fcscw212w8r";
  buildDepends = [ cereal network ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-socks";
    description = "Socks proxy (version 5) implementation";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
