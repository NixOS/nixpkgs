{ callPackage, fetchurl, ... }@_args:

let
  base = callPackage ./generic.nix (
    _args
    // {
      version = "8.5.0-alpha2";
      phpSrc = fetchurl {
        url = "https://downloads.php.net/~edorian/php-8.5.0alpha2.tar.xz";
        hash = "sha256-lNQagWiYjl+qdEeArYcO5Q3VF1tHRHfLcB/d3fGmlqE=";
      };
    }
  );
in
base.withExtensions (
  { all, ... }:
  with all;
  [
    bcmath
    calendar
    curl
    ctype
    dom
    exif
    fileinfo
    filter
    ftp
    gd
    gettext
    gmp
    iconv
    intl
    ldap
    mbstring
    mysqli
    mysqlnd
    opcache
    openssl
    pcntl
    pdo
    pdo_mysql
    pdo_odbc
    pdo_pgsql
    pdo_sqlite
    pgsql
    posix
    readline
    session
    simplexml
    sockets
    soap
    sodium
    sysvsem
    sqlite3
    tokenizer
    xmlreader
    xmlwriter
    zip
    zlib
  ]
)
