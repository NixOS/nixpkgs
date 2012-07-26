{ fetchurl, buildPerlPackage, DBI, postgresql }:

buildPerlPackage rec {
  name = "DBD-Pg-2.19.2";
  
  src = fetchurl {
    url = "mirror://cpan/modules/by-module/DBD/${name}.tar.gz";
    sha256 = "0scnhbp0lfclbppbsfzmcyw32z8jhb9calvbg9q3gk4kli1119j9";
  };
  
  buildInputs = [ postgresql ];
  propagatedBuildInputs = [ DBI ];
  
  makeMakerFlags = "POSTGRES_HOME=${postgresql}";
}
