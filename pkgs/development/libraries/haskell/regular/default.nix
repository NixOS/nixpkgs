{cabal}:

cabal.mkDerivation (self : {
  pname = "regular";
  version = "0.2.4";
  sha256 = "7fcef09b09b2bb8cb32246b96d659f8102fd749b6f064cd7b813835ce947932c";
  meta = {
    description = "Generic programming library for regular datatypes";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

