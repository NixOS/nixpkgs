{ stdenv, fetchurl, pkgconfig, openssl, libxslt, perl
, curl, pcre, libxml2, librdf_rasqal, gmp
, mysql, withMysql ? false
, postgresql, withPostgresql ? false
, sqlite, withSqlite ? true
, db, withBdb ? false
}:

stdenv.mkDerivation rec {
  name = "redland-1.0.17";

  src = fetchurl {
    url = "http://download.librdf.org/source/${name}.tar.gz";
    sha256 = "de1847f7b59021c16bdc72abb4d8e2d9187cd6124d69156f3326dd34ee043681";
  };

  nativeBuildInputs = [ perl pkgconfig ];

  buildInputs = [ openssl libxslt curl pcre libxml2 gmp ]
    ++ stdenv.lib.optional withMysql mysql.connector-c
    ++ stdenv.lib.optional withSqlite sqlite
    ++ stdenv.lib.optional withPostgresql postgresql
    ++ stdenv.lib.optional withBdb db;

  propagatedBuildInputs = [ librdf_rasqal ];

  postInstall = "rm -rvf $out/share/gtk-doc";

  configureFlags =
    [ "--with-threads" ]
    ++ stdenv.lib.optionals withBdb [
      "--with-bdb-include=${db.dev}/include"
      "--with-bdb-lib=${db.out}/lib"
    ];

  # Fix broken DT_NEEDED in lib/redland/librdf_storage_sqlite.so.
  NIX_CFLAGS_LINK = "-lraptor2";

  doCheck = false; # fails 1 out of 17 tests with a segmentation fault

  meta = {
    homepage = http://librdf.org/;
    platforms = stdenv.lib.platforms.unix;
  };
}
