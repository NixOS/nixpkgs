{ stdenv, fetchurl, pkgconfig, openssl, libxslt, perl
, curl, pcre, libxml2, librdf_rasqal
, mysql, withMysql ? false
, postgresql, withPostgresql ? false
, sqlite, withSqlite ? true
, db4, withBdb ? false
}:

stdenv.mkDerivation rec {
  name = "redland-1.0.14";

  src = fetchurl {
    url = "http://download.librdf.org/source/${name}.tar.gz";
    sha256 = "1i460q9gslb7l75hjwc6w2kp2wk7fgp8lr7phamg33c6j013y30k";
  };

  buildNativeInputs = [ perl pkgconfig ];

  buildInputs = [ openssl libxslt curl pcre libxml2 ]
    ++ stdenv.lib.optional withMysql mysql
    ++ stdenv.lib.optional withSqlite sqlite
    ++ stdenv.lib.optional withPostgresql postgresql
    ++ stdenv.lib.optional withBdb db4;

  propagatedBuildInputs = [ librdf_rasqal ];

  postInstall = "rm -rvf $out/share/gtk-doc";

  configureFlags =
    [ "--with-threads" ]
    ++ stdenv.lib.optional withBdb "--with-bdb=${db4}";

  meta = {
    homepage = http://librdf.org/;
  };
}
