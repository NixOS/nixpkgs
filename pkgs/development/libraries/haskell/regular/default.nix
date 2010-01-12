{cabal}:

cabal.mkDerivation (self : {
  pname = "regular";
  version = "0.2.1";
  sha256 = "732de15c4687b34a2702d38975581c8ab32167a76cd3c40cd4886bca0fc8b762";
  meta = {
    description = "Generic programming library for regular datatypes";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

