{fetchurl, buildPerlPackage, DBI, postgresql}:

buildPerlPackage {
  name = "DBD-Pg-2.13.1";
  
  src = fetchurl {
    url = mirror://cpan/authors/id/T/TU/TURNSTEP/DBD-Pg-2.13.1.tar.gz;
    sha256 = "9af40f47dc440b6ab031d6109ee694ef2d4a0aa899bc9870d8a992f2e4e6d1e6";
  };
  
  buildInputs = [postgresql] ;
  propagatedBuildInputs = [DBI];
  
  makeMakerFlags = "POSTGRES_HOME=${postgresql}";
}
