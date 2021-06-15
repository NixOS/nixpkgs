/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "str";
  version = "cl-20210411-git";

  description = "Modern, consistent and terse Common Lisp string manipulation library.";

  deps = [ args."cl-change-case" args."cl-ppcre" args."cl-ppcre-unicode" args."cl-unicode" args."flexi-streams" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-str/2021-04-11/cl-str-20210411-git.tgz";
    sha256 = "0xyazb3j4j0wsq443fpavv4hxnizkcvhkgz709lnp7cxygpdnl7m";
  };

  packageName = "str";

  asdFilesToKeep = ["str.asd"];
  overrides = x: x;
}
/* (SYSTEM str DESCRIPTION
    Modern, consistent and terse Common Lisp string manipulation library.
    SHA256 0xyazb3j4j0wsq443fpavv4hxnizkcvhkgz709lnp7cxygpdnl7m URL
    http://beta.quicklisp.org/archive/cl-str/2021-04-11/cl-str-20210411-git.tgz
    MD5 6c6b4de0886d448155a5cca0dd38a189 NAME str FILENAME str DEPS
    ((NAME cl-change-case FILENAME cl-change-case)
     (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME cl-ppcre-unicode FILENAME cl-ppcre-unicode)
     (NAME cl-unicode FILENAME cl-unicode)
     (NAME flexi-streams FILENAME flexi-streams))
    DEPENDENCIES
    (cl-change-case cl-ppcre cl-ppcre-unicode cl-unicode flexi-streams) VERSION
    cl-20210411-git SIBLINGS (str.test) PARASITES NIL) */
