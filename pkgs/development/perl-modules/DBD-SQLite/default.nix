{fetchurl, buildPerlPackage, DBI, sqlite}:

buildPerlPackage rec {
  name = "DBD-SQLite-1.29";
  
  src = fetchurl {
    url = "mirror://cpan/authors/id/A/AD/ADAMK/${name}.tar.gz";
    sha256 = "0rq8f9avaxqbnjq2zpd2knz2wsn8qiffnbbphp7a3bakwhlxbl2i";
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
