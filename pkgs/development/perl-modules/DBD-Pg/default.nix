{ stdenv, fetchurl, buildPerlPackage, DBI, postgresql }:

buildPerlPackage rec {
  name = "DBD-Pg-3.0.0";

  src = fetchurl {
    url = "mirror://cpan/authors/id/T/TU/TURNSTEP/${name}.tar.gz";
    sha256 = "10s1dhpxxqfl421388l6gzfdm1gzxf5iah42i1w6yji9mgkz8hf8";
  };

  buildInputs = [ postgresql ];
  propagatedBuildInputs = [ DBI ];

  makeMakerFlags = "POSTGRES_HOME=${postgresql}";

  meta = {
    homepage = http://search.cpan.org/dist/DBD-Pg/;
    description = "DBI PostgreSQL interface";
    license = stdenv.lib.licenses.perl5;
    platforms = stdenv.lib.platforms.linux;
  };
}
