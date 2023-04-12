/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-change-case";
  version = "20210411-git";

  parasites = [ "cl-change-case/test" ];

  description = "Convert strings between camelCase, param-case, PascalCase and more";

  deps = [ args."cl-ppcre" args."cl-ppcre-unicode" args."cl-unicode" args."fiveam" args."flexi-streams" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-change-case/2021-04-11/cl-change-case-20210411-git.tgz";
    sha256 = "14s26b907h1nsnwdqbj6j4c9bvc4rc2l8ry2q1j7ibjfzqvhp4mj";
  };

  packageName = "cl-change-case";

  asdFilesToKeep = ["cl-change-case.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-change-case DESCRIPTION
    Convert strings between camelCase, param-case, PascalCase and more SHA256
    14s26b907h1nsnwdqbj6j4c9bvc4rc2l8ry2q1j7ibjfzqvhp4mj URL
    http://beta.quicklisp.org/archive/cl-change-case/2021-04-11/cl-change-case-20210411-git.tgz
    MD5 df72a3d71a6c65e149704688aec859b9 NAME cl-change-case FILENAME
    cl-change-case DEPS
    ((NAME cl-ppcre FILENAME cl-ppcre)
     (NAME cl-ppcre-unicode FILENAME cl-ppcre-unicode)
     (NAME cl-unicode FILENAME cl-unicode) (NAME fiveam FILENAME fiveam)
     (NAME flexi-streams FILENAME flexi-streams))
    DEPENDENCIES (cl-ppcre cl-ppcre-unicode cl-unicode fiveam flexi-streams)
    VERSION 20210411-git SIBLINGS NIL PARASITES (cl-change-case/test)) */
