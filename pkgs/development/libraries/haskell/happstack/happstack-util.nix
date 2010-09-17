{cabal, mtl, hslogger, HUnit, QuickCheck, strictConcurrency,
 unixCompat, SMTPClient}:

cabal.mkDerivation (self : {
    pname = "happstack-util";
    version = "0.5.0.2";
    sha256 = "b6a84a55d6f7aec51095121a240bd6096b0df3c61c6fd25963d91190fcca4657";
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
