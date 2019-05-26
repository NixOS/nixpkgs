args @ { fetchurl, ... }:
rec {
  baseName = ''nibbles'';
  version = ''20180831-git'';

  parasites = [ "nibbles/tests" ];

  description = ''A library for accessing octet-addressed blocks of data in big- and little-endian orders'';

  deps = [ args."rt" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/nibbles/2018-08-31/nibbles-20180831-git.tgz'';
    sha256 = ''0z25f2z54pnz1s35prqvnl42bv0xqh50y94bds1jwfv0wvfq27la'';
  };

  packageName = "nibbles";

  asdFilesToKeep = ["nibbles.asd"];
  overrides = x: x;
}
/* (SYSTEM nibbles DESCRIPTION
    A library for accessing octet-addressed blocks of data in big- and little-endian orders
    SHA256 0z25f2z54pnz1s35prqvnl42bv0xqh50y94bds1jwfv0wvfq27la URL
    http://beta.quicklisp.org/archive/nibbles/2018-08-31/nibbles-20180831-git.tgz
    MD5 4badf1f066a59c3c270d40be1116ecd5 NAME nibbles FILENAME nibbles DEPS
    ((NAME rt FILENAME rt)) DEPENDENCIES (rt) VERSION 20180831-git SIBLINGS NIL
    PARASITES (nibbles/tests)) */
