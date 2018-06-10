{ fetchurl, buildPerlPackage, DBI, freetds }:

buildPerlPackage rec {
  name = "DBD-Sybase-1.16";

  src = fetchurl {
    url = "mirror://cpan/authors/id/M/ME/MEWP/${name}.tar.gz";
    sha256 = "1k6n261nrrcll9wxn5xwi4ibpavqv1il96687k62mbpznzl2gx37";
  };

  SYBASE = freetds;

  buildInputs = [ freetds ] ;
  propagatedBuildInputs = [ DBI ];

  doCheck = false;
}
