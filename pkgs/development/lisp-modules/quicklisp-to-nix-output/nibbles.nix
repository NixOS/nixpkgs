args @ { fetchurl, ... }:
rec {
  baseName = ''nibbles'';
  version = ''20200925-git'';

  parasites = [ "nibbles/tests" ];

  description = ''A library for accessing octet-addressed blocks of data in big- and little-endian orders'';

  deps = [ args."rt" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/nibbles/2020-09-25/nibbles-20200925-git.tgz'';
    sha256 = ''14k9hg8kmzwcb9b5aiwqhimc0zmcs3xp8q29sck8zklf8ziqaqb4'';
  };

  packageName = "nibbles";

  asdFilesToKeep = ["nibbles.asd"];
  overrides = x: x;
}
/* (SYSTEM nibbles DESCRIPTION
    A library for accessing octet-addressed blocks of data in big- and little-endian orders
    SHA256 14k9hg8kmzwcb9b5aiwqhimc0zmcs3xp8q29sck8zklf8ziqaqb4 URL
    http://beta.quicklisp.org/archive/nibbles/2020-09-25/nibbles-20200925-git.tgz
    MD5 2e6275cac23e28e24a25201d7d6e4ae2 NAME nibbles FILENAME nibbles DEPS
    ((NAME rt FILENAME rt)) DEPENDENCIES (rt) VERSION 20200925-git SIBLINGS NIL
    PARASITES (nibbles/tests)) */
