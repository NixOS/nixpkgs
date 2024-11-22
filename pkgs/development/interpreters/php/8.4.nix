{ callPackage, fetchurl, ... }@_args:

let
  base = callPackage ./generic.nix (
    _args
    // {
      version = "8.4.0RC4";
      phpSrc = fetchurl {
        url = "https://downloads.php.net/~calvinb/php-8.4.0RC4.tar.xz";
        hash = "sha256-s/ihnYRfSqVlAV/4YZZAfrUzKE60NlrFlT9edK5h3LA=";
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
