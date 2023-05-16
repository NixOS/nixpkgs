<<<<<<< HEAD
{ callPackage, ... }@_args:

let
  base = callPackage ./generic.nix (_args // {
    version = "8.2.10";
    hash = "sha256-zJg06PG2E9dneviEPDZR6YKavKjr/pB5JR0Nhdmgqj4=";
=======
{ callPackage, lib, stdenv, fetchurl, ... }@_args:

let
  base = callPackage ./generic.nix (_args // {
    version = "8.2.6";
    hash = "sha256-RKcMUvU3ZiwQ2R7tv1H9dlyZYb5rolCO1jv3omzdMQA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
