{ fetchurl, buildPerlPackage, DBI, mysql }:

buildPerlPackage rec {
  name = "DBD-mysql-4.039";

  src = fetchurl {
    url = "mirror://cpan/authors/id/C/CA/CAPTTOFU/${name}.tar.gz";
    sha256 = "0k4p3bjdbmxm2amb0qiiwmn8v83zrjkz5qp84xdjrg8k5v9aj0hn";
  };

  buildInputs = [ mysql.lib ] ;
  propagatedBuildInputs = [ DBI ];

  doCheck = false;

#  makeMakerFlags = "MYSQL_HOME=${mysql}";
}
