{ callPackage, ... }@_args:

let
  base = callPackage ./generic.nix (
    _args
    // {
      version = "8.3.26";
      hash = "sha256-chtj1TSfEx9Ql1N7O+a6aAHi2Ob6uh8fLqlbT9YudSU=";
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
    imap
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
