{ callPackage, fetchpatch, ... }@_args:

let
  base = callPackage ./generic.nix ((removeAttrs _args [ "fetchpatch" ]) // {
    version = "8.1.31";
    hash = "sha256-CzmCizRRUcrxt5XZ9LkjyYhyMXdsMwdt/J2QpEOQ0Nw=";
  });
in
base.withExtensions ({ all, ... }: with all; ([
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
]))
