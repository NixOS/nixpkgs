/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "ieee-floats";
  version = "20170830-git";

  parasites = [ "ieee-floats-tests" ];

  description = "Convert floating point values to IEEE 754 binary representation";

  deps = [ args."fiveam" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/ieee-floats/2017-08-30/ieee-floats-20170830-git.tgz";
    sha256 = "15c4q4w3cda82vqlpvdfrnah6ms6vxbjf4a0chd10daw72rwayqk";
  };

  packageName = "ieee-floats";

  asdFilesToKeep = ["ieee-floats.asd"];
  overrides = x: x;
}
/* (SYSTEM ieee-floats DESCRIPTION
    Convert floating point values to IEEE 754 binary representation SHA256
    15c4q4w3cda82vqlpvdfrnah6ms6vxbjf4a0chd10daw72rwayqk URL
    http://beta.quicklisp.org/archive/ieee-floats/2017-08-30/ieee-floats-20170830-git.tgz
    MD5 3434b4d91224ca6a817ced9d83f14bb6 NAME ieee-floats FILENAME ieee-floats
    DEPS ((NAME fiveam FILENAME fiveam)) DEPENDENCIES (fiveam) VERSION
    20170830-git SIBLINGS NIL PARASITES (ieee-floats-tests)) */
