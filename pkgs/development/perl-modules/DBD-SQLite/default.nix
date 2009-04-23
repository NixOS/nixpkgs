{fetchurl, buildPerlPackage, DBI, sqlite}:

buildPerlPackage {
  name = "DBD-SQLite-1.14";
  
  src = fetchurl {
    url = mirror://cpan/authors/id/M/MS/MSERGEANT/DBD-SQLite-1.14.tar.gz;
    sha256 = "01qd5xfx702chg3bv2k727kfdp84zy5xh31y6njvivkp78vrs624";
  };
  
  propagatedBuildInputs = [DBI];
  
  makeMakerFlags = "SQLITE_LOCATION=${sqlite}";

  patches = [
    # Prevent segfaults in case of timeouts.
    ./reset.patch
  ];

  # Disabled because the tests can randomly fail due to timeouts
  # (e.g. "database is locked(5) at dbdimp.c line 402 at t/07busy.t").
  doCheck = false;
}
