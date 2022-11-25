{ callPackage, lib, stdenv, fetchurl, ... }@_args:

let
  hash = "sha256-MSBENMUl+F5k9manZvYjRDY3YWsYToZSQU9hmhJ8Xvc=";

  base = callPackage ./generic.nix (_args // {
    version = "8.2.0";
    phpAttrsOverrides = attrs: attrs // {
      src = fetchurl {
        url = "https://downloads.php.net/~pierrick/php-8.2.0RC7.tar.xz";
        inherit hash;
      };
    };
    inherit hash;
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
