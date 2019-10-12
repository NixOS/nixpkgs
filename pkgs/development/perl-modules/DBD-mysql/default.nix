{ fetchurl, buildPerlPackage, DBI, DevelChecklib, libmysqlclient }:

buildPerlPackage {
  pname = "DBD-mysql";
  version = "4.050";

  src = fetchurl {
    url = mirror://cpan/authors/id/D/DV/DVEEDEN/DBD-mysql-4.050.tar.gz;
    sha256 = "0y4djb048i09dk19av7mzfb3khr72vw11p3ayw2p82jsy4gm8j2g";
  };

  buildInputs = [ libmysqlclient DevelChecklib ] ;
  propagatedBuildInputs = [ DBI ];

  doCheck = false;

#  makeMakerFlags = "MYSQL_HOME=${mysql}";
}
