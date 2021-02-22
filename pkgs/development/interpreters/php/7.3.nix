{ callPackage, lib, stdenv, nixosTests, ... }@_args:

let
  generic = (import ./generic.nix) _args;

  base = callPackage generic (_args // {
    version = "7.3.27";
    sha256 = "00z0vadxazm2flks9g8qmchj2pwkli880kg313jgbb1mx3shc84x";

    # https://bugs.php.net/bug.php?id=76826
    extraPatches = lib.optional stdenv.isDarwin ./php73-darwin-isfinite.patch;
  });

in base.withExtensions ({ all, ... }: with all; ([
  bcmath calendar curl ctype dom exif fileinfo filter ftp gd
  gettext gmp hash iconv intl json ldap mbstring mysqli mysqlnd
  opcache openssl pcntl pdo pdo_mysql pdo_odbc pdo_pgsql pdo_sqlite
  pgsql posix readline session simplexml sockets soap sodium sqlite3
  tokenizer xmlreader xmlwriter zip zlib
] ++ lib.optionals (!stdenv.isDarwin) [ imap ]))
