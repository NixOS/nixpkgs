{ fetchurl, buildPerlPackage, DBI, mysql }:

buildPerlPackage rec {
  name = "DBD-mysql-4.046";

  src = fetchurl {
    url = "mirror://cpan/authors/id/C/CA/CAPTTOFU/${name}.tar.gz";
    sha256 = "1xziv9w87cl3fbl1mqkdrx28mdqly3gs6gs1ynbmpl2rr4p6arb1";
  };

  buildInputs = [ mysql.connector-c ] ;
  propagatedBuildInputs = [ DBI ];

  doCheck = false;

#  makeMakerFlags = "MYSQL_HOME=${mysql}";
}
