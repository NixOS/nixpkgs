{ fetchurl, buildPerlPackage, DBI, mysql }:

buildPerlPackage rec {
  name = "DBD-mysql-4.041";

  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MI/MICHIELB/${name}.tar.gz";
    sha256 = "0h4h6zwzj8fwh9ljb8svnsa0a3ch4p10hp59kpdibdb4qh8xwxs7";
  };

  buildInputs = [ mysql.connector-c ] ;
  propagatedBuildInputs = [ DBI ];

  doCheck = false;

#  makeMakerFlags = "MYSQL_HOME=${mysql}";
}
