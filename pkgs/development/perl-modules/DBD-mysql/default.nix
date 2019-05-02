{ fetchurl, buildPerlPackage, DBI, DevelChecklib, mysql }:

buildPerlPackage rec {
  name = "DBD-mysql-4.050";

  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DV/DVEEDEN/${name}.tar.gz";
    sha256 = "0y4djb048i09dk19av7mzfb3khr72vw11p3ayw2p82jsy4gm8j2g";
  };

  buildInputs = [ mysql.connector-c DevelChecklib ] ;
  propagatedBuildInputs = [ DBI ];

  doCheck = false;

#  makeMakerFlags = "MYSQL_HOME=${mysql}";
}
