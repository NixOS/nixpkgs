{fetchurl, buildPerlPackage, DBI, sqlite}:

buildPerlPackage rec {
  name = "DBD-SQLite-1.25";
  
  src = fetchurl {
    url = "mirror://cpan/authors/id/A/AD/ADAMK/${name}.tar.gz";
    sha256 = "17dd09jhf2kk33rqlsg74c1sb049qabmyh857alqc9fhffd1yb43";
  };
  
  propagatedBuildInputs = [DBI];
  
  makeMakerFlags = "SQLITE_LOCATION=${sqlite}";

  patches = [
    # Support building against our own sqlite.
    ./external-sqlite.patch
  ];

  # Disabled because the tests can randomly fail due to timeouts
  # (e.g. "database is locked(5) at dbdimp.c line 402 at t/07busy.t").
  #doCheck = false;
}
