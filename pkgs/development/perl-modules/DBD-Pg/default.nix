{ stdenv, fetchurl, buildPerlPackage, DBI, postgresql }:

buildPerlPackage rec {
  name = "DBD-Pg-3.5.3";

  src = fetchurl {
    url = "mirror://cpan/authors/id/T/TU/TURNSTEP/${name}.tar.gz";
    sha256 = "03m9w1cd0yyrbqwkwcl92j1cpmasmm69f3hwvcrlfsi5fnwsk63y";
  };

  buildInputs = [ postgresql ];
  propagatedBuildInputs = [ DBI ];

  makeMakerFlags = "POSTGRES_HOME=${postgresql}";

  meta = {
    homepage = http://search.cpan.org/dist/DBD-Pg/;
    description = "DBI PostgreSQL interface";
    license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    platforms = stdenv.lib.platforms.unix;
  };
}
