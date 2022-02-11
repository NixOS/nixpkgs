/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "parenscript";
  version = "Parenscript-2.7.1";

  description = "Lisp to JavaScript transpiler";

  deps = [ args."anaphora" args."cl-ppcre" args."named-readtables" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/parenscript/2018-12-10/Parenscript-2.7.1.tgz";
    sha256 = "1vbldjzj9py8vqyk0f3rb795cjai0h7p858dflm4l8p0kp4mll6f";
  };

  packageName = "parenscript";

  asdFilesToKeep = ["parenscript.asd"];
  overrides = x: x;
}
/* (SYSTEM parenscript DESCRIPTION Lisp to JavaScript transpiler SHA256
    1vbldjzj9py8vqyk0f3rb795cjai0h7p858dflm4l8p0kp4mll6f URL
    http://beta.quicklisp.org/archive/parenscript/2018-12-10/Parenscript-2.7.1.tgz
    MD5 047c9a72bd36f1b4a5ec67af9453a0b9 NAME parenscript FILENAME parenscript
    DEPS
    ((NAME anaphora FILENAME anaphora) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME named-readtables FILENAME named-readtables))
    DEPENDENCIES (anaphora cl-ppcre named-readtables) VERSION Parenscript-2.7.1
    SIBLINGS (parenscript.tests) PARASITES NIL) */
