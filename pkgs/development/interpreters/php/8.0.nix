{ callPackage, lib, stdenv, ... }@_args:

let
  base = callPackage ./generic.nix (_args // {
    version = "8.0.26";
    hash = "sha256-bfh6+W8nWnWIns5uP+ShOr2Tp2epmShjvcDpDx6Ifuc=";
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
