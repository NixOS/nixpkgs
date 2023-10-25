/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "physical-quantities";
  version = "20211020-git";

  parasites = [ "physical-quantities/test" ];

  description = "A library that provides a numeric type with optional unit and/or uncertainty for computations with automatic error propagation.";

  deps = [ args."parseq" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/physical-quantities/2021-10-20/physical-quantities-20211020-git.tgz";
    sha256 = "1ix04gjcsjzry5rl1rqsrg1r3hw985gfvl1847va36y03qzbmhgx";
  };

  packageName = "physical-quantities";

  asdFilesToKeep = ["physical-quantities.asd"];
  overrides = x: x;
}
/* (SYSTEM physical-quantities DESCRIPTION
    A library that provides a numeric type with optional unit and/or uncertainty for computations with automatic error propagation.
    SHA256 1ix04gjcsjzry5rl1rqsrg1r3hw985gfvl1847va36y03qzbmhgx URL
    http://beta.quicklisp.org/archive/physical-quantities/2021-10-20/physical-quantities-20211020-git.tgz
    MD5 a322db845056f78a237630a565b41490 NAME physical-quantities FILENAME
    physical-quantities DEPS ((NAME parseq FILENAME parseq)) DEPENDENCIES
    (parseq) VERSION 20211020-git SIBLINGS NIL PARASITES
    (physical-quantities/test)) */
