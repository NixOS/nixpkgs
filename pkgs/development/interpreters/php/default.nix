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
    version = "8.2.33";
    hash = "sha256-U2Lyp6DnFoznIv6gBIsaHSjg98wmXEF99nDGVnBpUBg=";
  };
  php83 = mkPhp {
    version = "8.3.33";
    hash = "sha256-+cn00M12ksbj2jY81MpyqCakmuGPXtQwtvyue8KIHhg=";
  };
  php84 = mkPhp {
    version = "8.4.24";
    hash = "sha256-KGiQRHWIUQ3xEO3p6c4J8etPmFZjC0f9xA7OcOIDc88=";
  };
  php85 = mkPhp {
    version = "8.5.9";
    hash = "sha256-cDwIKtnSlGrGR/NZaBIwDSxis2DS8xqZkCFpKps5R2w=";
  };
}
