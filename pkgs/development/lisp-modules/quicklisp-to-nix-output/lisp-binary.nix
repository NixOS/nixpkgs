/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "lisp-binary";
  version = "20220220-git";

  description = "Declare binary formats as structs and then read and write them.";

  deps = [ args."alexandria" args."babel" args."cffi" args."closer-mop" args."flexi-streams" args."iterate" args."moptilities" args."quasiquote-2_dot_0" args."trivial-features" args."trivial-gray-streams" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/lisp-binary/2022-02-20/lisp-binary-20220220-git.tgz";
    sha256 = "1fr4pj6c65ndhaixmby3xgr1nb6qpap9dn9gddvwxsl1jxks9cw3";
  };

  packageName = "lisp-binary";

  asdFilesToKeep = ["lisp-binary.asd"];
  overrides = x: x;
}
/* (SYSTEM lisp-binary DESCRIPTION
    Declare binary formats as structs and then read and write them. SHA256
    1fr4pj6c65ndhaixmby3xgr1nb6qpap9dn9gddvwxsl1jxks9cw3 URL
    http://beta.quicklisp.org/archive/lisp-binary/2022-02-20/lisp-binary-20220220-git.tgz
    MD5 af14f9a7ce07b38f5c7af3666a9d5ac2 NAME lisp-binary FILENAME lisp-binary
    DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cffi FILENAME cffi) (NAME closer-mop FILENAME closer-mop)
     (NAME flexi-streams FILENAME flexi-streams)
     (NAME iterate FILENAME iterate) (NAME moptilities FILENAME moptilities)
     (NAME quasiquote-2.0 FILENAME quasiquote-2_dot_0)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams))
    DEPENDENCIES
    (alexandria babel cffi closer-mop flexi-streams iterate moptilities
     quasiquote-2.0 trivial-features trivial-gray-streams)
    VERSION 20220220-git SIBLINGS (lisp-binary-test) PARASITES NIL) */
