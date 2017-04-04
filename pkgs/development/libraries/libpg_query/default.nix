{ fetchFromGitHub, stdenv }:

stdenv.mkDerivation rec {
  name = "libpg_query-${version}";
  version = "9.5-1.4.2";

  src = fetchFromGitHub {
    owner  = "lfittl";
    repo   = "libpg_query";
    rev    = version;
    sha256 = "0jd6c2ykfm1a32my4a6lqlvsk8flxjh2ma3rp1fxrzygzyinz4l3";
  };

  installPhase = ''
    mkdir -p $out/lib $out/include
    cp libpg_query.a $out/lib
    cp pg_query.h $out/include
  '';

  meta = {
    homepage = https://github.com/lfittl/libpg_query;
    description = "C library for accessing the PostgreSQL parser outside of the server environment";
    longDescription = ''
      This library uses the actual PostgreSQL server source to parse
      SQL queries and return the internal PostgreSQL parse tree.
    '';
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.unix;
  };
}
