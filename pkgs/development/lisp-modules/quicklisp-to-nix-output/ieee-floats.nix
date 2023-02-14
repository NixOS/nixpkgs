/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "ieee-floats";
  version = "20220220-git";

  parasites = [ "ieee-floats/tests" ];

  description = "Convert floating point values to IEEE 754 binary representation";

  deps = [ args."fiveam" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/ieee-floats/2022-02-20/ieee-floats-20220220-git.tgz";
    sha256 = "0iaigf6961cnwhsfh4hwgshkid57ba4mjjwsdbwh1a0yzmcd7mbd";
  };

  packageName = "ieee-floats";

  asdFilesToKeep = ["ieee-floats.asd"];
  overrides = x: x;
}
/* (SYSTEM ieee-floats DESCRIPTION
    Convert floating point values to IEEE 754 binary representation SHA256
    0iaigf6961cnwhsfh4hwgshkid57ba4mjjwsdbwh1a0yzmcd7mbd URL
    http://beta.quicklisp.org/archive/ieee-floats/2022-02-20/ieee-floats-20220220-git.tgz
    MD5 91237afb503d64fc7164cf7776a203ba NAME ieee-floats FILENAME ieee-floats
    DEPS ((NAME fiveam FILENAME fiveam)) DEPENDENCIES (fiveam) VERSION
    20220220-git SIBLINGS NIL PARASITES (ieee-floats/tests)) */
