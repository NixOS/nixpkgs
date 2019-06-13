{ stdenv, fetchurl, buildPerlPackage, DBI, postgresql }:

buildPerlPackage rec {
  name = "DBD-Pg-3.7.4";

  src = fetchurl {
    url = "mirror://cpan/authors/id/T/TU/TURNSTEP/${name}.tar.gz";
    sha256 = "0gkqlvbmzbdm0g4k328nlkjdg3wrjm5i2n9jxj1i8sqxkm79rylz";
  };

  buildInputs = [ postgresql ];
  propagatedBuildInputs = [ DBI ];

  makeMakerFlags = "POSTGRES_HOME=${postgresql}";

  # tests freeze in a sandbox
  doCheck = false;

  meta = {
    description = "DBI PostgreSQL interface";
    license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    platforms = stdenv.lib.platforms.unix;
  };
}
