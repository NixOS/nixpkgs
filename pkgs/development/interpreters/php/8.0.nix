{ callPackage, lib, stdenv, nixosTests, ... }@_args:

let
  generic = (import ./generic.nix) _args;

  base = callPackage generic (_args // {
    version = "8.0.0";
    sha256 = "0fhn9dfgczf4g8p3ilw3c38nwdvkbnvz6sa92k8z7gszyjvd5rzv";
  });

in base.withExtensions ({ all, ... }: with all; ([
  bcmath calendar curl ctype dom exif fileinfo filter ftp gd
  gettext gmp iconv intl ldap mbstring mysqli mysqlnd opcache
  openssl pcntl pdo pdo_mysql pdo_odbc pdo_pgsql pdo_sqlite pgsql
  posix readline session simplexml sockets soap sodium sqlite3
  tokenizer xmlreader xmlwriter zip zlib
] ++ lib.optionals (!stdenv.isDarwin) [ imap ]))
