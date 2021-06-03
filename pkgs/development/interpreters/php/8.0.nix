{ callPackage, lib, stdenv, nixosTests, ... }@_args:

let
  generic = (import ./generic.nix) _args;

  base = callPackage generic (_args // {
    version = "8.0.6";
    sha256 = "0vjji49a8pbhzy1q6l4id95ixar2dqf1bkqbxffh64k0svdaka16";
  });

in base.withExtensions ({ all, ... }: with all; ([
  bcmath calendar curl ctype dom exif fileinfo filter ftp gd
  gettext gmp iconv intl ldap mbstring mysqli mysqlnd opcache
  openssl pcntl pdo pdo_mysql pdo_odbc pdo_pgsql pdo_sqlite pgsql
  posix readline session simplexml sockets soap sodium sqlite3
  tokenizer xmlreader xmlwriter zip zlib
] ++ lib.optionals (!stdenv.isDarwin) [ imap ]))
