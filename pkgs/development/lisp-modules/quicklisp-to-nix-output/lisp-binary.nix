/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "lisp-binary";
  version = "20210411-git";

  description = "Declare binary formats as structs and then read and write them.";

  deps = [ args."alexandria" args."babel" args."cffi" args."closer-mop" args."flexi-streams" args."iterate" args."moptilities" args."quasiquote-2_dot_0" args."trivial-features" args."trivial-gray-streams" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/lisp-binary/2021-04-11/lisp-binary-20210411-git.tgz";
    sha256 = "1sbapl8qla4xb8wcix9yxpijkbk1bpybhay7ncb3z2im7r2kzsnb";
  };

  packageName = "lisp-binary";

  asdFilesToKeep = ["lisp-binary.asd"];
  overrides = x: x;
}
/* (SYSTEM lisp-binary DESCRIPTION
    Declare binary formats as structs and then read and write them. SHA256
    1sbapl8qla4xb8wcix9yxpijkbk1bpybhay7ncb3z2im7r2kzsnb URL
    http://beta.quicklisp.org/archive/lisp-binary/2021-04-11/lisp-binary-20210411-git.tgz
    MD5 29d85f01a1cb17742164bacae940d29c NAME lisp-binary FILENAME lisp-binary
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
    VERSION 20210411-git SIBLINGS (lisp-binary-test) PARASITES NIL) */
