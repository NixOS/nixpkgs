{ callPackage, lib, stdenv, fetchurl, ... }@_args:

let
  hash = "sha256-sbT8sIwle3OugXxqLZO3jKXlrOQsX1iH7WRH8G+nv8Y=";

  base = callPackage ./generic.nix (_args // {
    version = "8.2.0";
    phpAttrsOverrides = attrs: attrs // {
      src = fetchurl {
        url = "https://downloads.php.net/~sergey/php-8.2.0RC6.tar.xz";
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
