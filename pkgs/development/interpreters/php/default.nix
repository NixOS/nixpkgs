{
  lib,
  callPackage,
  stdenv,
  llvmPackages,
  pcre2,
}:

let
  mkPhp =
    { version, hash }:
    let
      base = callPackage ./generic.nix {
        stdenv = if stdenv.cc.isClang then llvmPackages.stdenv else stdenv;
        pcre2 = pcre2.override {
          withJitSealloc = false; # See https://bugs.php.net/bug.php?id=78927 and https://bugs.php.net/bug.php?id=78630
        };
        inherit version hash;
      };
    in
    base.withExtensions (
      { all, ... }:
      with all;
      [
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
        intl
        ldap
        mbstring
        mysqli
        mysqlnd
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
      ]
      ++ lib.optionals (lib.versionOlder version "8.4") [ all.imap ]
      ++ lib.optionals (lib.versionOlder version "8.5") [ all.opcache ]
    );
in
{
  php82 = mkPhp {
    version = "8.2.36";
    hash = "sha256-9DBrStpgJjfvNd8uD0qgWdVZlSvIeSbtdG+tKwp3e3I=";
  };
  php83 = mkPhp {
    version = "8.3.37";
    hash = "sha256-eDe0PNThjbXerCHubwCGbkd5pwXy5U+uqDyKbPVv0dg=";
  };
  php84 = mkPhp {
    version = "8.4.28";
    hash = "sha256-sjqhvlt0YprWJP0BNlwOTfbYh4RzmD8zc0lDPvNJwfc=";
  };
  php85 = mkPhp {
    version = "8.5.13";
    hash = "sha256-R9UMNgFnhKSnHwGc17+inDHkvg3iLT+gYJWygKYpni8=";
  };
}
