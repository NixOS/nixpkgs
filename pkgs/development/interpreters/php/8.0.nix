{ callPackage, lib, stdenv, ... }@_args:

let
  base = callPackage ./generic.nix (_args // {
    version = "8.0.25";
    hash = "sha256-CdcWvOtbPbdtkCOxDBaB674EDlH0wY39Nfn/i3O7z4w=";
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
  sqlite3
  tokenizer
  xmlreader
  xmlwriter
  zip
  zlib
] ++ lib.optionals (!stdenv.isDarwin) [ imap ]))
