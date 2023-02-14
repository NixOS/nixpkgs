/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "str";
  version = "cl-20220220-git";

  description = "Modern, consistent and terse Common Lisp string manipulation library.";

  deps = [ args."cl-change-case" args."cl-ppcre" args."cl-ppcre-unicode" args."cl-unicode" args."flexi-streams" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-str/2022-02-20/cl-str-20220220-git.tgz";
    sha256 = "12gkp2vj3q57p17zh41s0minq30bwz6z1d1ir4x69gay2s27q5yd";
  };

  packageName = "str";

  asdFilesToKeep = ["str.asd"];
  overrides = x: x;
}
/* (SYSTEM str DESCRIPTION
    Modern, consistent and terse Common Lisp string manipulation library.
    SHA256 12gkp2vj3q57p17zh41s0minq30bwz6z1d1ir4x69gay2s27q5yd URL
    http://beta.quicklisp.org/archive/cl-str/2022-02-20/cl-str-20220220-git.tgz
    MD5 311b14274123e99d8182d86c2dc3dcf0 NAME str FILENAME str DEPS
    ((NAME cl-change-case FILENAME cl-change-case)
     (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME cl-ppcre-unicode FILENAME cl-ppcre-unicode)
     (NAME cl-unicode FILENAME cl-unicode)
     (NAME flexi-streams FILENAME flexi-streams))
    DEPENDENCIES
    (cl-change-case cl-ppcre cl-ppcre-unicode cl-unicode flexi-streams) VERSION
    cl-20220220-git SIBLINGS (str.test) PARASITES NIL) */
