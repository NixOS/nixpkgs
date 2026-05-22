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
    version = "8.2.31";
    hash = "sha256-lIGD+gTPJhybk2PAL0KJd7nd+MC/3/jo4fuoFu1XCAM=";
  };
  php83 = mkPhp {
    version = "8.3.31";
    hash = "sha256-5phrH9N+slQCEn/kpyeKPgO3+QJbt6S9KSonG9+TD7k=";
  };
  php84 = mkPhp {
    version = "8.4.21";
    hash = "sha256-XgvSh/O+Nb9XwhGwEFJ65eEKiBcPluZNM2BE61+u9DA=";
  };
  php85 = mkPhp {
    version = "8.5.6";
    hash = "sha256-RFckD2XwxZpiCSDWbNqxsSEApDHgOtn+vjixOhsllX8=";
  };
}
