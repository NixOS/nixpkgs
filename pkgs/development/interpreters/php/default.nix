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
    version = "8.2.30";
    hash = "sha256-EEggtsj8lZ3eSzNCE19CvavyRuhpGKFjgaF9hEfIZvo=";
  };
  php83 = mkPhp {
    version = "8.3.30";
    hash = "sha256-gAt7btULc8jueETuXy98xhL6p4daCqfEUp6O1YZqUDA=";
  };
  php84 = mkPhp {
    version = "8.4.21";
    hash = "sha256-XgvSh/O+Nb9XwhGwEFJ65eEKiBcPluZNM2BE61+u9DA=";
  };
  php85 = mkPhp {
    version = "8.5.5";
    hash = "sha256-7iYr7/YcQxll0flxkoVLNiCK3qw4mDw0mLs1AK6HKDw=";
  };
}
