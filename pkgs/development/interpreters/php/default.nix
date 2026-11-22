{
  lib,
  callPackage,
  stdenv,
  llvmPackages,
  pcre2,
}:

let
  mkPhp =
    {
      version,
      hash ? null,
      phpSrc ? null,
      knownVulnerabilities ? [ ],
    }:
    let
      base = callPackage ./generic.nix {
        stdenv = if stdenv.cc.isClang then llvmPackages.stdenv else stdenv;
        inherit
          version
          hash
          phpSrc
          knownVulnerabilities
          ;
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
  # NOTE TO all contributors: from 2026-11 we no longer accept release candidates.

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
  php86 = mkPhp {
    version = "8.6.0";
    hash = "sha256-niM+OJmaifNRozrmpydtHK9a3cuhHgnju+Oo0l9BH/E=";
  };
}
