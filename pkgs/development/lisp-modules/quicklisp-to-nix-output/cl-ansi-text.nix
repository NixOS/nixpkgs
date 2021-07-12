/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-ansi-text";
  version = "20210124-git";

  description = "ANSI control string characters, focused on color";

  deps = [ args."alexandria" args."cl-colors2" args."cl-ppcre" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-ansi-text/2021-01-24/cl-ansi-text-20210124-git.tgz";
    sha256 = "1l7slqk26xznfyn0zpp5l32v6xfpj4qj42h4x4ds5s1yncq306cm";
  };

  packageName = "cl-ansi-text";

  asdFilesToKeep = ["cl-ansi-text.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-ansi-text DESCRIPTION
    ANSI control string characters, focused on color SHA256
    1l7slqk26xznfyn0zpp5l32v6xfpj4qj42h4x4ds5s1yncq306cm URL
    http://beta.quicklisp.org/archive/cl-ansi-text/2021-01-24/cl-ansi-text-20210124-git.tgz
    MD5 76f54998b056919978737815468e31b6 NAME cl-ansi-text FILENAME
    cl-ansi-text DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME cl-colors2 FILENAME cl-colors2) (NAME cl-ppcre FILENAME cl-ppcre))
    DEPENDENCIES (alexandria cl-colors2 cl-ppcre) VERSION 20210124-git SIBLINGS
    (cl-ansi-text.test) PARASITES NIL) */
