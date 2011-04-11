{fetchurl, buildPerlPackage, DBI, sqlite}:

buildPerlPackage rec {
  name = "DBD-SQLite-1.31";
  
  src = fetchurl {
    url = "mirror://cpan/authors/id/A/AD/ADAMK/${name}.tar.gz";
    sha256 = "1xi9bfxfndb4kajixc1y7rrz2sjjv2z7vcm5msrxznx3vr358zlq";
  };
  
  propagatedBuildInputs = [DBI];
  
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
