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
    version = "8.2.32";
    hash = "sha256-jyHpiMpN1eFN2fuImIRIeENWbkhygAJ8Tvq2yTGIotE=";
  };
  php83 = mkPhp {
    version = "8.3.32";
    hash = "sha256-93fKJGYZZvlLMfaEDNrUN88wUBU324uHKxt6HCRLjQI=";
  };
  php84 = mkPhp {
    version = "8.4.23";
    hash = "sha256-wULAY7EM/2jQcnZuP/v7NlSgibk4ZosIMDVkN+6V4Po=";
  };
  php85 = mkPhp {
    version = "8.5.8";
    hash = "sha256-Ivk478bE6qi/LkCuEUZhQDCUlqpdWhkgQnL7JZb9Ed0=";
  };
}
