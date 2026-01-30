{ callPackage, ... }@_args:

let
  base = callPackage ./generic.nix (
    _args
    // {
      version = "8.5.2";
      hash = "sha256-9+/ezMOoELGJIGkjBlNrmaO6hmENvQeVopbPd9P7OgY=";
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
