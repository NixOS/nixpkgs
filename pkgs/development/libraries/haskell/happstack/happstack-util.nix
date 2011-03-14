{cabal, mtl, hslogger, HUnit, QuickCheck, strictConcurrency,
 unixCompat, SMTPClient}:

cabal.mkDerivation (self : {
    pname = "happstack-util";
    version = "0.5.0.3";
    sha256 = "1ipr09d0s1d0dffc1g3js8infhybw9rimabrl96a2vw7app3ys44";
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
