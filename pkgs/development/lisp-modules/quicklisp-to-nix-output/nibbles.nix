/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "nibbles";
  version = "20210531-git";

  parasites = [ "nibbles/tests" ];

  description = "A library for accessing octet-addressed blocks of data in big- and little-endian orders";

  deps = [ args."rt" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/nibbles/2021-05-31/nibbles-20210531-git.tgz";
    sha256 = "1gwk44l86z6yyyn1fqf72rvlh93i61v6430njl9c6cmm05hf8lzz";
  };

  packageName = "nibbles";

  asdFilesToKeep = ["nibbles.asd"];
  overrides = x: x;
}
/* (SYSTEM nibbles DESCRIPTION
    A library for accessing octet-addressed blocks of data in big- and little-endian orders
    SHA256 1gwk44l86z6yyyn1fqf72rvlh93i61v6430njl9c6cmm05hf8lzz URL
    http://beta.quicklisp.org/archive/nibbles/2021-05-31/nibbles-20210531-git.tgz
    MD5 ec4ee1a201aef6325e071a9d9e3f6380 NAME nibbles FILENAME nibbles DEPS
    ((NAME rt FILENAME rt)) DEPENDENCIES (rt) VERSION 20210531-git SIBLINGS NIL
    PARASITES (nibbles/tests)) */
