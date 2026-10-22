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
    version = "8.2.35";
    hash = "sha256-D0Pv0awk1PkAAsjU1XC/TE1Z+hQxO/JwqujPBNnf3vM=";
  };
  php83 = mkPhp {
    version = "8.3.36";
    hash = "sha256-RvS0XjaI7SsYGQFae1MsFbUcwFW907E/0A3f7r7tzV8=";
  };
  php84 = mkPhp {
    version = "8.4.27";
    hash = "sha256-slMKh3xyL0sIyeF0owywi6wrfhkD7m6eMV8KqfX4LCQ=";
  };
  php85 = mkPhp {
    version = "8.5.12";
    hash = "sha256-/7YO3EN87WO1E35JhNs3moERxQBJxxFRDYuVgnfvwag=";
  };
}
