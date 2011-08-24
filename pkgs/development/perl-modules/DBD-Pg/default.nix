{ fetchurl, buildPerlPackage, DBI, postgresql }:

buildPerlPackage rec {
  name = "DBD-Pg-2.18.1";
  
  src = fetchurl {
    url = "mirror://cpan/modules/by-module/DBD/${name}.tar.gz";
    sha256 = "10nrmi0hgc9h8c0jbpd9bbbzkdb1riymnlk7a86537c0d4gfqcpm";
  };
  
  buildInputs = [postgresql] ;
  propagatedBuildInputs = [DBI];
  
  makeMakerFlags = "POSTGRES_HOME=${postgresql}";
}
