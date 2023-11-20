{ callPackage, fetchurl, ... }@_args:

let
  base = (callPackage ./generic.nix (_args // {
    version = "8.3.0RC2";
    hash = null;
  })).overrideAttrs (oldAttrs: {
    src = fetchurl {
      url = "https://downloads.php.net/~eric/php-8.3.0RC2.tar.xz";
      hash = "sha256-0Lo9msTyjfU9kuq0QkvUv4yeshM2tUizMJb9oCggMtw=";
    };
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
