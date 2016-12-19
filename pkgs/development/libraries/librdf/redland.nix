{ stdenv, fetchurl, pkgconfig, openssl, libxslt, perl
, curl, pcre, libxml2, librdf_rasqal
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

  buildInputs = [ openssl libxslt curl pcre libxml2 ]
    ++ stdenv.lib.optional withMysql mysql
    ++ stdenv.lib.optional withSqlite sqlite
    ++ stdenv.lib.optional withPostgresql postgresql
    ++ stdenv.lib.optional withBdb db;

  propagatedBuildInputs = [ librdf_rasqal ];

  postInstall = "rm -rvf $out/share/gtk-doc";

  configureFlags =
    [ "--with-threads" ]
    ++ stdenv.lib.optional withBdb "--with-bdb=${db}";

  # Fix broken DT_NEEDED in lib/redland/librdf_storage_sqlite.so.
  NIX_CFLAGS_LINK = "-lraptor2";

  meta = {
    homepage = http://librdf.org/;
    platforms = stdenv.lib.platforms.linux;
  };
}
