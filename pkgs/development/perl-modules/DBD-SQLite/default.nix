{fetchurl, buildPerlPackage, DBI, sqlite}:

buildPerlPackage rec {
  name = "DBD-SQLite-1.35";
  
  src = fetchurl {
    url = "mirror://cpan/authors/id/A/AD/ADAMK/${name}.tar.gz";
    sha256 = "0zdwnj0jmkaqb2grkh451g1jc8nsdy4sf6lhn8xd0my0a3pd227z";
  };
  
  propagatedBuildInputs = [ DBI ];
  
  makeMakerFlags = "SQLITE_LOCATION=${sqlite}";

  patches = [
    # Support building against our own sqlite.
    ./external-sqlite.patch
  ];

  # Prevent warnings from `strip'.
  postInstall = "chmod -R u+w $out";

  # Disabled because the tests can randomly fail due to timeouts
  # (e.g. "database is locked(5) at dbdimp.c line 402 at t/07busy.t").
  doCheck = false;
}
