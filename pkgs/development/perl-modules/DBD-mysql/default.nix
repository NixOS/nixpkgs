{fetchurl, buildPerlPackage, DBI, mysql}:

buildPerlPackage {
  name = "DBD-mysql-4.013";

  src = fetchurl {
    url = mirror://cpan/authors/id/C/CA/CAPTTOFU/DBD-mysql-4.013.tar.gz;
    sha256 = "074jm3fd9bi9am4i8alwim5i7a4gl07hzjy7a7hfdj9awbd0w9x9";
  };

  buildInputs = [mysql] ;
  propagatedBuildInputs = [DBI];

#  makeMakerFlags = "MYSQL_HOME=${mysql}";
}
