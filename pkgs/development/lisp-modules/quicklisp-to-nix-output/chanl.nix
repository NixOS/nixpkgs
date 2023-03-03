/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "chanl";
  version = "20210411-git";

  parasites = [ "chanl/examples" "chanl/tests" ];

  description = "Communicating Sequential Process support for Common Lisp";

  deps = [ args."alexandria" args."bordeaux-threads" args."fiveam" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/chanl/2021-04-11/chanl-20210411-git.tgz";
    sha256 = "1c1yiw616q5hv6vzyg1y4kg68v94p37s5jrq387rwadfnnf46rgi";
  };

  packageName = "chanl";

  asdFilesToKeep = ["chanl.asd"];
  overrides = x: x;
}
/* (SYSTEM chanl DESCRIPTION
    Communicating Sequential Process support for Common Lisp SHA256
    1c1yiw616q5hv6vzyg1y4kg68v94p37s5jrq387rwadfnnf46rgi URL
    http://beta.quicklisp.org/archive/chanl/2021-04-11/chanl-20210411-git.tgz
    MD5 efaa5705b5feaa718290d25a95e2a684 NAME chanl FILENAME chanl DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME fiveam FILENAME fiveam))
    DEPENDENCIES (alexandria bordeaux-threads fiveam) VERSION 20210411-git
    SIBLINGS NIL PARASITES (chanl/examples chanl/tests)) */
