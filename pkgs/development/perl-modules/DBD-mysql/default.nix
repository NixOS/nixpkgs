{fetchurl, buildPerlPackage, DBI, mysql}:

buildPerlPackage {
  name = "DBD-mysql-4.023";

  src = fetchurl {
    url = mirror://cpan/authors/id/C/CA/CAPTTOFU/DBD-mysql-4.023.tar.gz;
    sha256 = "0j4i0i6apjwx5klk3wigh6yysssn7bs6p8c5sh31m6qxsbgyk9xa";
  };

  buildInputs = [mysql] ;
  propagatedBuildInputs = [DBI];

#  makeMakerFlags = "MYSQL_HOME=${mysql}";
}
