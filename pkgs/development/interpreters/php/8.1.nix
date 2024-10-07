{ callPackage, fetchpatch, ... }@_args:

let
  base = callPackage ./generic.nix ((removeAttrs _args [ "fetchpatch" ]) // {
    version = "8.1.30";
    hash = "sha256-yxYl5axJuRA3R34+d2e7BiQ0OXGuuZL0eRthivVx0j4=";
    extraPatches = [
      # Fix build with libxml2 2.12+.
      # Patch from https://github.com/php/php-src/commit/0a39890c967aa57225bb6bdf4821aff7a3a3c082
      (fetchpatch {
        url = "https://github.com/php/php-src/commit/0a39890c967aa57225bb6bdf4821aff7a3a3c082.patch";
        hash = "sha256-HvpTL7aXO9gr4glFdhqUWQPrG8TYTlvbNINq33M3zS0=";
      })
      # Fix tests with libxml2 2.12
      (fetchpatch {
        url = "https://github.com/php/php-src/commit/061058a9b1bbd90d27d97d79aebcf2b5029767b0.patch";
        hash = "sha256-0hOlAG+pOYp/gUU0MUMZvzWpgr0ncJi5GB8IeNxxyEU=";
        excludes = [
          "NEWS"
        ];
      })
      # Backport of PHP_LIBXML_IGNORE_DEPRECATIONS_START and PHP_LIBXML_IGNORE_DEPRECATIONS_END
      # Required for libxml2 2.13 compatibility patch.
      ./php81-fix-libxml2-2.13-compatibility.patch
      # Fix build with libxml2 2.13+. Has to be applied after libxml2 2.12 patch.
      (fetchpatch {
        url = "https://github.com/php/php-src/commit/9b4f6b09d58a4e54ee60443bf9a8b166852c03e0.patch";
        hash = "sha256-YC3I0BQi3o3+VmRu/UqpqPpaSC+ekPqzbORTHftbPvY=";
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
