{ callPackage, lib, stdenv, ... }@_args:

let
  base = callPackage ./generic.nix (_args // {
    version = "7.4.26";
    sha256 = "0k803j5wf4jv72px0zqz2z2hxyk2w3jr6xyczy568dx4z2l8i2yn";
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
  json
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
