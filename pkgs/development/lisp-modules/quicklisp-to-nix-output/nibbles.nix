/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "nibbles";
  version = "20210124-git";

  parasites = [ "nibbles/tests" ];

  description = "A library for accessing octet-addressed blocks of data in big- and little-endian orders";

  deps = [ args."rt" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/nibbles/2021-01-24/nibbles-20210124-git.tgz";
    sha256 = "0y3h4k7665w7b8ivmql9w6rz3ivfa3h8glk45sn6mwix55xmzp26";
  };

  packageName = "nibbles";

  asdFilesToKeep = ["nibbles.asd"];
  overrides = x: x;
}
/* (SYSTEM nibbles DESCRIPTION
    A library for accessing octet-addressed blocks of data in big- and little-endian orders
    SHA256 0y3h4k7665w7b8ivmql9w6rz3ivfa3h8glk45sn6mwix55xmzp26 URL
    http://beta.quicklisp.org/archive/nibbles/2021-01-24/nibbles-20210124-git.tgz
    MD5 e37b58da46b4756006e790e658f35ea8 NAME nibbles FILENAME nibbles DEPS
    ((NAME rt FILENAME rt)) DEPENDENCIES (rt) VERSION 20210124-git SIBLINGS NIL
    PARASITES (nibbles/tests)) */
