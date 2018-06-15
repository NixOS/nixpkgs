args @ { fetchurl, ... }:
rec {
  baseName = ''nibbles'';
  version = ''20180430-git'';

  parasites = [ "nibbles/tests" ];

  description = ''A library for accessing octet-addressed blocks of data in big- and little-endian orders'';

  deps = [ args."rt" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/nibbles/2018-04-30/nibbles-20180430-git.tgz'';
    sha256 = ''1z79x7w0qp66vdxq7lac1jkc56brmpy0x0wmm9flf91d8y9lh34g'';
  };

  packageName = "nibbles";

  asdFilesToKeep = ["nibbles.asd"];
  overrides = x: x;
}
/* (SYSTEM nibbles DESCRIPTION
    A library for accessing octet-addressed blocks of data in big- and little-endian orders
    SHA256 1z79x7w0qp66vdxq7lac1jkc56brmpy0x0wmm9flf91d8y9lh34g URL
    http://beta.quicklisp.org/archive/nibbles/2018-04-30/nibbles-20180430-git.tgz
    MD5 8d8d1cc72ce11253d01854219ea20a06 NAME nibbles FILENAME nibbles DEPS
    ((NAME rt FILENAME rt)) DEPENDENCIES (rt) VERSION 20180430-git SIBLINGS NIL
    PARASITES (nibbles/tests)) */
