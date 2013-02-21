{ stdenv, fetchurl, buildPerlPackage, DBI, postgresql }:

buildPerlPackage rec {
  name = "DBD-Pg-2.19.3";

  src = fetchurl {
    url = "mirror://cpan/modules/by-module/DBD/${name}.tar.gz";
    sha256 = "0ai6p2094hrh6kjlwfjvpw2z8wqa3scr4ba3p6rqza3z9c9hsd9p";
  };

  buildInputs = [ postgresql ];
  propagatedBuildInputs = [ DBI ];

  makeMakerFlags = "POSTGRES_HOME=${postgresql}";

  meta = {
    homepage = http://search.cpan.org/dist/DBD-Pg/;
    description = "DBI PostgreSQL interface";
    license = "perl";
    platforms = stdenv.lib.platforms.linux;
  };
}
