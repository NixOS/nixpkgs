{ cabal, cereal, conduit, cryptoApi, transformers }:

cabal.mkDerivation (self: {
  pname = "crypto-conduit";
  version = "0.4.0";
  sha256 = "15x7v6vmmd90mrb60wllvdai8fk8cvm5bkxzzqyjikshldvlhmas";
  buildDepends = [ cereal conduit cryptoApi transformers ];
  meta = {
    homepage = "https://github.com/meteficha/crypto-conduit";
    description = "Conduit interface for cryptographic operations (from crypto-api)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
