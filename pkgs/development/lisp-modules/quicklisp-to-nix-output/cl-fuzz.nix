/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-fuzz";
  version = "20181018-git";

  description = "A Fuzz Testing Framework";

  deps = [ args."alexandria" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-fuzz/2018-10-18/cl-fuzz-20181018-git.tgz";
    sha256 = "1kxh73lbnhzzpflab1vpxsmg4qia9n42sij0459iksi29kmjxjpz";
  };

  packageName = "cl-fuzz";

  asdFilesToKeep = ["cl-fuzz.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-fuzz DESCRIPTION A Fuzz Testing Framework SHA256
    1kxh73lbnhzzpflab1vpxsmg4qia9n42sij0459iksi29kmjxjpz URL
    http://beta.quicklisp.org/archive/cl-fuzz/2018-10-18/cl-fuzz-20181018-git.tgz
    MD5 22e715b370ea886bbff1e09db20c4e32 NAME cl-fuzz FILENAME cl-fuzz DEPS
    ((NAME alexandria FILENAME alexandria)) DEPENDENCIES (alexandria) VERSION
    20181018-git SIBLINGS NIL PARASITES NIL) */
