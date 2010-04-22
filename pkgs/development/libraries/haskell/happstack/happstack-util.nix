{cabal, mtl, hslogger, HUnit, QuickCheck, strictConcurrency,
 unixCompat, SMTPClient}:

cabal.mkDerivation (self : {
    pname = "happstack-util";
    version = "0.4.1";
    sha256 = "bb254140c30c39c420bc5a649da645f59df950f0a712c2dac4de1cc6572f05f9";
    propagatedBuildInputs = [
      mtl hslogger HUnit QuickCheck strictConcurrency unixCompat
      SMTPClient
    ];
    meta = {
        description = "Miscellaneous utilities for Happstack packages";
        license = "BSD";
        maintainers = [self.stdenv.lib.maintainers.andres];
    };
})
