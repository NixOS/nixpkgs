/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "array-operations";
  version = "20220220-git";

  parasites = [ "array-operations/tests" ];

  description = "Simple array operations library for Common Lisp.";

  deps = [ args."alexandria" args."anaphora" args."clunit2" args."let-plus" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/array-operations/2022-02-20/array-operations-20220220-git.tgz";
    sha256 = "0c326nl5hssx9ffh1wi0xqk9ii68djzfaw6vr9npygx4da9lssrl";
  };

  packageName = "array-operations";

  asdFilesToKeep = ["array-operations.asd"];
  overrides = x: x;
}
/* (SYSTEM array-operations DESCRIPTION
    Simple array operations library for Common Lisp. SHA256
    0c326nl5hssx9ffh1wi0xqk9ii68djzfaw6vr9npygx4da9lssrl URL
    http://beta.quicklisp.org/archive/array-operations/2022-02-20/array-operations-20220220-git.tgz
    MD5 9bdd752321c39e98699bc07800b582e7 NAME array-operations FILENAME
    array-operations DEPS
    ((NAME alexandria FILENAME alexandria) (NAME anaphora FILENAME anaphora)
     (NAME clunit2 FILENAME clunit2) (NAME let-plus FILENAME let-plus))
    DEPENDENCIES (alexandria anaphora clunit2 let-plus) VERSION 20220220-git
    SIBLINGS NIL PARASITES (array-operations/tests)) */
