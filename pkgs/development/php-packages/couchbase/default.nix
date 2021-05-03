{ lib, buildPecl, fetchFromGitHub, writeText, libcouchbase, zlib, php }:
let
  pname = "couchbase";
  version = "2.6.2";
in
buildPecl {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "couchbase";
    repo = "php-couchbase";
    rev = "v${version}";
    sha256 = "0ymrymnz91qg9b2ns044qg46wc65dffhxx402wpx1b5cj2vr4ma3";
  };

  configureFlags = [ "--with-couchbase" ];
  broken = lib.versionAtLeast php.version "8.0";

  buildInputs = [ libcouchbase zlib ];
  internalDeps = lib.optionals (lib.versionOlder php.version "8.0") [ php.extensions.json ];
  peclDeps = [ php.extensions.igbinary ];

  patches = [
    (writeText "php-couchbase.patch" ''
      --- a/config.m4
      +++ b/config.m4
      @@ -9,7 +9,7 @@ if test "$PHP_COUCHBASE" != "no"; then
           LIBCOUCHBASE_DIR=$PHP_COUCHBASE
         else
           AC_MSG_CHECKING(for libcouchbase in default path)
      -    for i in /usr/local /usr; do
      +    for i in ${libcouchbase}; do
             if test -r $i/include/libcouchbase/couchbase.h; then
               LIBCOUCHBASE_DIR=$i
               AC_MSG_RESULT(found in $i)
      @@ -154,6 +154,8 @@ COUCHBASE_FILES=" \
           igbinary_inc_path="$phpincludedir"
         elif test -f "$phpincludedir/ext/igbinary/igbinary.h"; then
           igbinary_inc_path="$phpincludedir"
      +  elif test -f "${php.extensions.igbinary.dev}/include/ext/igbinary/igbinary.h"; then
      +    igbinary_inc_path="${php.extensions.igbinary.dev}/include"
         fi
         if test "$igbinary_inc_path" = ""; then
           AC_MSG_WARN([Cannot find igbinary.h])
    '')
  ];

  meta.maintainers = lib.teams.php.members;
}
