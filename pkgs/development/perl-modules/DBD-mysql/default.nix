{ fetchurl, buildPerlPackage, DBI, mysql }:

buildPerlPackage rec {
  name = "DBD-mysql-4.033";

  src = fetchurl {
    url = "mirror://cpan/authors/id/C/CA/CAPTTOFU/${name}.tar.gz";
    sha256 = "0769xakykps0cx368g4vaips4w3bjk383rianiavq7sq6g6bp66c";
  };

  buildInputs = [ mysql.lib ] ;
  propagatedBuildInputs = [ DBI ];

  doCheck = false;

#  makeMakerFlags = "MYSQL_HOME=${mysql}";
}
