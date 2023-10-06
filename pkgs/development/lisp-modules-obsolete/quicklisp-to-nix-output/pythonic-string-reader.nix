/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "pythonic-string-reader";
  version = "20180711-git";

  description = "A simple and unintrusive read table modification that allows for
simple string literal definition that doesn't require escaping characters.";

  deps = [ args."named-readtables" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/pythonic-string-reader/2018-07-11/pythonic-string-reader-20180711-git.tgz";
    sha256 = "0gr6sbkmfwca9r0xa5vczjm4s9psbrqy5hvijkp5g42b0b7x5myx";
  };

  packageName = "pythonic-string-reader";

  asdFilesToKeep = ["pythonic-string-reader.asd"];
  overrides = x: x;
}
/* (SYSTEM pythonic-string-reader DESCRIPTION
    A simple and unintrusive read table modification that allows for
simple string literal definition that doesn't require escaping characters.
    SHA256 0gr6sbkmfwca9r0xa5vczjm4s9psbrqy5hvijkp5g42b0b7x5myx URL
    http://beta.quicklisp.org/archive/pythonic-string-reader/2018-07-11/pythonic-string-reader-20180711-git.tgz
    MD5 8156636895b1148fad6e7bcedeb6b556 NAME pythonic-string-reader FILENAME
    pythonic-string-reader DEPS
    ((NAME named-readtables FILENAME named-readtables)) DEPENDENCIES
    (named-readtables) VERSION 20180711-git SIBLINGS NIL PARASITES NIL) */
