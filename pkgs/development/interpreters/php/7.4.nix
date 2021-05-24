{ callPackage, lib, stdenv, nixosTests, ... }@_args:

let
  generic = (import ./generic.nix) _args;

  base = callPackage generic (_args // {
    version = "7.4.18";
    sha256 = "0bw4q7svijsqi5vinaspzzqyli2pvmpz6yf83ndqixf6x4r5ji9f";
  });

in base.withExtensions ({ all, ... }: with all; ([
  bcmath calendar curl ctype dom exif fileinfo filter ftp gd
  gettext gmp iconv intl json ldap mbstring mysqli mysqlnd opcache
  openssl pcntl pdo pdo_mysql pdo_odbc pdo_pgsql pdo_sqlite pgsql
  posix readline session simplexml sockets soap sodium sqlite3
  tokenizer xmlreader xmlwriter zip zlib
] ++ lib.optionals (!stdenv.isDarwin) [ imap ]))
