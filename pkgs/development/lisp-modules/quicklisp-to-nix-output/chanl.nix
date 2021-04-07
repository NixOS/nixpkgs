/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "chanl";
  version = "20210124-git";

  parasites = [ "chanl/examples" "chanl/tests" ];

  description = "Communicating Sequential Process support for Common Lisp";

  deps = [ args."alexandria" args."bordeaux-threads" args."fiveam" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/chanl/2021-01-24/chanl-20210124-git.tgz";
    sha256 = "1lb0k5nh51f8hskpm1pma5ds4lk1zpbk9czpw9bk8hdykr178mzc";
  };

  packageName = "chanl";

  asdFilesToKeep = ["chanl.asd"];
  overrides = x: x;
}
/* (SYSTEM chanl DESCRIPTION
    Communicating Sequential Process support for Common Lisp SHA256
    1lb0k5nh51f8hskpm1pma5ds4lk1zpbk9czpw9bk8hdykr178mzc URL
    http://beta.quicklisp.org/archive/chanl/2021-01-24/chanl-20210124-git.tgz
    MD5 2f9e2d16caa2febff4f5beb6226b7ccf NAME chanl FILENAME chanl DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME fiveam FILENAME fiveam))
    DEPENDENCIES (alexandria bordeaux-threads fiveam) VERSION 20210124-git
    SIBLINGS NIL PARASITES (chanl/examples chanl/tests)) */
