{ fetchurl, buildPerlPackage, DBI, TestNoWarnings, oracle-instantclient }:

buildPerlPackage rec {
  name = "DBD-Oracle-1.76";

  src = fetchurl {
    url = "mirror://cpan/authors/id/Z/ZA/ZARQUON/${name}.tar.gz";
    sha256 = "b6db7f43c6252179274cfe99c1950b93e248f8f0fe35b07e50388c85d814d5f3";
  };

  ORACLE_HOME = "${oracle-instantclient}/lib";

  buildInputs = [ TestNoWarnings oracle-instantclient ] ;
  propagatedBuildInputs = [ DBI ];
}
