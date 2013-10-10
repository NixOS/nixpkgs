{ cabal, cereal, network }:

cabal.mkDerivation (self: {
  pname = "socks";
  version = "0.5.3";
  sha256 = "0cajbl7vrljawaxl3vbbf0sq92ry3cj925sww4nw70lhpz96ay4x";
  buildDepends = [ cereal network ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-socks";
    description = "Socks proxy (version 5) implementation";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
