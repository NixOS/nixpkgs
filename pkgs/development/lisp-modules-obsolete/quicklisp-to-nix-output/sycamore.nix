/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "sycamore";
  version = "20211020-git";

  description = "A fast, purely functional data structure library";

  deps = [ args."alexandria" args."cl-fuzz" args."cl-ppcre" args."lisp-unit" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/sycamore/2021-10-20/sycamore-20211020-git.tgz";
    sha256 = "1msh2kpd96s7jfm565snf71bbsmnjmsf8b31y1xg9vkk7xp01cf4";
  };

  packageName = "sycamore";

  asdFilesToKeep = ["sycamore.asd"];
  overrides = x: x;
}
/* (SYSTEM sycamore DESCRIPTION
    A fast, purely functional data structure library SHA256
    1msh2kpd96s7jfm565snf71bbsmnjmsf8b31y1xg9vkk7xp01cf4 URL
    http://beta.quicklisp.org/archive/sycamore/2021-10-20/sycamore-20211020-git.tgz
    MD5 0a9f35519b5cb3e5f9467427632ff0f8 NAME sycamore FILENAME sycamore DEPS
    ((NAME alexandria FILENAME alexandria) (NAME cl-fuzz FILENAME cl-fuzz)
     (NAME cl-ppcre FILENAME cl-ppcre) (NAME lisp-unit FILENAME lisp-unit))
    DEPENDENCIES (alexandria cl-fuzz cl-ppcre lisp-unit) VERSION 20211020-git
    SIBLINGS NIL PARASITES NIL) */
