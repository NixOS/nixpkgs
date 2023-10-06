/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "fare-quasiquote-optima";
  version = "fare-quasiquote-20200925-git";

  description = "fare-quasiquote extension for optima";

  deps = [ args."alexandria" args."closer-mop" args."fare-quasiquote" args."fare-quasiquote-readtable" args."fare-utils" args."lisp-namespace" args."named-readtables" args."trivia_dot_level0" args."trivia_dot_level1" args."trivia_dot_level2" args."trivia_dot_quasiquote" args."trivia_dot_trivial" args."trivial-cltl2" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/fare-quasiquote/2020-09-25/fare-quasiquote-20200925-git.tgz";
    sha256 = "0k25kx4gvr046bcnv5mqxbb4483v9p2lk7dvzjkgj2cxrvczmj8b";
  };

  packageName = "fare-quasiquote-optima";

  asdFilesToKeep = ["fare-quasiquote-optima.asd"];
  overrides = x: x;
}
/* (SYSTEM fare-quasiquote-optima DESCRIPTION
    fare-quasiquote extension for optima SHA256
    0k25kx4gvr046bcnv5mqxbb4483v9p2lk7dvzjkgj2cxrvczmj8b URL
    http://beta.quicklisp.org/archive/fare-quasiquote/2020-09-25/fare-quasiquote-20200925-git.tgz
    MD5 7af0a97c445d88acacecfc851496adb3 NAME fare-quasiquote-optima FILENAME
    fare-quasiquote-optima DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME closer-mop FILENAME closer-mop)
     (NAME fare-quasiquote FILENAME fare-quasiquote)
     (NAME fare-quasiquote-readtable FILENAME fare-quasiquote-readtable)
     (NAME fare-utils FILENAME fare-utils)
     (NAME lisp-namespace FILENAME lisp-namespace)
     (NAME named-readtables FILENAME named-readtables)
     (NAME trivia.level0 FILENAME trivia_dot_level0)
     (NAME trivia.level1 FILENAME trivia_dot_level1)
     (NAME trivia.level2 FILENAME trivia_dot_level2)
     (NAME trivia.quasiquote FILENAME trivia_dot_quasiquote)
     (NAME trivia.trivial FILENAME trivia_dot_trivial)
     (NAME trivial-cltl2 FILENAME trivial-cltl2))
    DEPENDENCIES
    (alexandria closer-mop fare-quasiquote fare-quasiquote-readtable fare-utils
     lisp-namespace named-readtables trivia.level0 trivia.level1 trivia.level2
     trivia.quasiquote trivia.trivial trivial-cltl2)
    VERSION fare-quasiquote-20200925-git SIBLINGS
    (fare-quasiquote-extras fare-quasiquote-readtable fare-quasiquote)
    PARASITES NIL) */
