/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "sycamore";
  version = "20200610-git";

  description = "A fast, purely functional data structure library";

  deps = [ args."alexandria" args."cl-fuzz" args."cl-ppcre" args."lisp-unit" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/sycamore/2020-06-10/sycamore-20200610-git.tgz";
    sha256 = "0dn4vmbyz1ix34hjnmzjw8imh2s1p52y6fvgx2ppyqr61vdzn34p";
  };

  packageName = "sycamore";

  asdFilesToKeep = ["sycamore.asd"];
  overrides = x: x;
}
/* (SYSTEM sycamore DESCRIPTION
    A fast, purely functional data structure library SHA256
    0dn4vmbyz1ix34hjnmzjw8imh2s1p52y6fvgx2ppyqr61vdzn34p URL
    http://beta.quicklisp.org/archive/sycamore/2020-06-10/sycamore-20200610-git.tgz
    MD5 7e06bc7db251f8f60231ff966846c7d4 NAME sycamore FILENAME sycamore DEPS
    ((NAME alexandria FILENAME alexandria) (NAME cl-fuzz FILENAME cl-fuzz)
     (NAME cl-ppcre FILENAME cl-ppcre) (NAME lisp-unit FILENAME lisp-unit))
    DEPENDENCIES (alexandria cl-fuzz cl-ppcre lisp-unit) VERSION 20200610-git
    SIBLINGS NIL PARASITES NIL) */
