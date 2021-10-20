/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "physical-quantities";
  version = "20201220-git";

  parasites = [ "physical-quantities/test" ];

  description = "A library that provides a numeric type with optional unit and/or uncertainty for computations with automatic error propagation.";

  deps = [ args."parseq" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/physical-quantities/2020-12-20/physical-quantities-20201220-git.tgz";
    sha256 = "0731q6skgnl95jmw82pfkw6y3bdaw5givdlgbk93jql251wfvmf5";
  };

  packageName = "physical-quantities";

  asdFilesToKeep = ["physical-quantities.asd"];
  overrides = x: x;
}
/* (SYSTEM physical-quantities DESCRIPTION
    A library that provides a numeric type with optional unit and/or uncertainty for computations with automatic error propagation.
    SHA256 0731q6skgnl95jmw82pfkw6y3bdaw5givdlgbk93jql251wfvmf5 URL
    http://beta.quicklisp.org/archive/physical-quantities/2020-12-20/physical-quantities-20201220-git.tgz
    MD5 428232d463c45259dd2c18fa8ff3dd6e NAME physical-quantities FILENAME
    physical-quantities DEPS ((NAME parseq FILENAME parseq)) DEPENDENCIES
    (parseq) VERSION 20201220-git SIBLINGS NIL PARASITES
    (physical-quantities/test)) */
