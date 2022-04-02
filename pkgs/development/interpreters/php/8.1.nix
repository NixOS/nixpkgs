{ callPackage, lib, stdenv, ... }@_args:

let
  base = callPackage ./generic.nix (_args // {
    version = "8.1.4";
    sha256 = "b3f688cb69758523838b8e7f509aaef0152133d9b84a84a0b7cf68eeafc1df76";
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
