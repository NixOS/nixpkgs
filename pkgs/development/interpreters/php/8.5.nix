{ callPackage, fetchurl, ... }@_args:

let
  base = callPackage ./generic.nix (
    _args
    // {
      version = "8.5.0-alpha1";
      phpSrc = fetchurl {
        url = "https://downloads.php.net/~daniels/php-8.5.0alpha1.tar.xz";
        hash = "sha256-8hwgezUN6FVbljCnrH0Ik8VTGG8bUCcjZyiynMmf5LQ=";
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
