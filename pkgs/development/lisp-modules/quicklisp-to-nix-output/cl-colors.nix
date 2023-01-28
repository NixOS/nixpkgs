/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-colors";
  version = "20180328-git";

  parasites = [ "cl-colors-tests" ];

  description = "Simple color library for Common Lisp";

  deps = [ args."alexandria" args."anaphora" args."let-plus" args."lift" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-colors/2018-03-28/cl-colors-20180328-git.tgz";
    sha256 = "0anrb3zsi03dixfsjz92y06w93kpn0d0c5142fhx72f5kafwvc4a";
  };

  packageName = "cl-colors";

  asdFilesToKeep = ["cl-colors.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-colors DESCRIPTION Simple color library for Common Lisp SHA256
    0anrb3zsi03dixfsjz92y06w93kpn0d0c5142fhx72f5kafwvc4a URL
    http://beta.quicklisp.org/archive/cl-colors/2018-03-28/cl-colors-20180328-git.tgz
    MD5 5e59ea59b32a0254df9610a5662ae2ec NAME cl-colors FILENAME cl-colors DEPS
    ((NAME alexandria FILENAME alexandria) (NAME anaphora FILENAME anaphora)
     (NAME let-plus FILENAME let-plus) (NAME lift FILENAME lift))
    DEPENDENCIES (alexandria anaphora let-plus lift) VERSION 20180328-git
    SIBLINGS NIL PARASITES (cl-colors-tests)) */
