{ cabal }:

cabal.mkDerivation (self: {
  pname = "type-equality";
  version = "0.1.1";
  sha256 = "0sgb7aki0ns3547y3abv1xh9rlmwhjm1c370pf3jjssysayh2wzv";
  meta = {
    homepage = "http://github.com/hesselink/type-equality/";
    description = "Type equality, coercion/cast and other operations";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
