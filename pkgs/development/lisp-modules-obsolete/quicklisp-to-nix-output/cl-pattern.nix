/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-pattern";
  version = "20140713-git";

  description = "System lacks description";

  deps = [ args."alexandria" args."cl-annot" args."cl-syntax" args."cl-syntax-annot" args."named-readtables" args."trivial-types" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-pattern/2014-07-13/cl-pattern-20140713-git.tgz";
    sha256 = "08z7jccjcq41i3i5zdsgixqnijgyrb4q7hm7gq8l5xb1sr3kj72v";
  };

  packageName = "cl-pattern";

  asdFilesToKeep = ["cl-pattern.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-pattern DESCRIPTION System lacks description SHA256
    08z7jccjcq41i3i5zdsgixqnijgyrb4q7hm7gq8l5xb1sr3kj72v URL
    http://beta.quicklisp.org/archive/cl-pattern/2014-07-13/cl-pattern-20140713-git.tgz
    MD5 cf8e74def535c66a358df1ada9d89785 NAME cl-pattern FILENAME cl-pattern
    DEPS
    ((NAME alexandria FILENAME alexandria) (NAME cl-annot FILENAME cl-annot)
     (NAME cl-syntax FILENAME cl-syntax)
     (NAME cl-syntax-annot FILENAME cl-syntax-annot)
     (NAME named-readtables FILENAME named-readtables)
     (NAME trivial-types FILENAME trivial-types))
    DEPENDENCIES
    (alexandria cl-annot cl-syntax cl-syntax-annot named-readtables
     trivial-types)
    VERSION 20140713-git SIBLINGS (cl-pattern-benchmark) PARASITES NIL) */
