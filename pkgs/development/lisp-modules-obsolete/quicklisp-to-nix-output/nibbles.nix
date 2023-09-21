/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "nibbles";
  version = "20211209-git";

  parasites = [ "nibbles/tests" ];

  description = "A library for accessing octet-addressed blocks of data in big- and little-endian orders";

  deps = [ args."rt" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/nibbles/2021-12-09/nibbles-20211209-git.tgz";
    sha256 = "1zkywrhz8p09pwdsa2mklr0yspqvvwa5fi6cz22n1z6fzvxz7m2s";
  };

  packageName = "nibbles";

  asdFilesToKeep = ["nibbles.asd"];
  overrides = x: x;
}
/* (SYSTEM nibbles DESCRIPTION
    A library for accessing octet-addressed blocks of data in big- and little-endian orders
    SHA256 1zkywrhz8p09pwdsa2mklr0yspqvvwa5fi6cz22n1z6fzvxz7m2s URL
    http://beta.quicklisp.org/archive/nibbles/2021-12-09/nibbles-20211209-git.tgz
    MD5 c6e7348a8a979da7cd4852b5df8a4384 NAME nibbles FILENAME nibbles DEPS
    ((NAME rt FILENAME rt)) DEPENDENCIES (rt) VERSION 20211209-git SIBLINGS NIL
    PARASITES (nibbles/tests)) */
