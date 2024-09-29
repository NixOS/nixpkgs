{ callPackage, fetchpatch, ... }@_args:

let
  base = callPackage ./generic.nix ((removeAttrs _args [ "fetchpatch" ]) // {
    version = "8.1.30";
    hash = "sha256-yxYl5axJuRA3R34+d2e7BiQ0OXGuuZL0eRthivVx0j4=";
    extraPatches = [
      # Fix build with libxml 2.12+.
      # Patch from https://github.com/php/php-src/commit/0a39890c967aa57225bb6bdf4821aff7a3a3c082
      (fetchpatch {
        url = "https://github.com/php/php-src/commit/0a39890c967aa57225bb6bdf4821aff7a3a3c082.patch";
        hash = "sha256-HvpTL7aXO9gr4glFdhqUWQPrG8TYTlvbNINq33M3zS0=";
      })
    ];
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
