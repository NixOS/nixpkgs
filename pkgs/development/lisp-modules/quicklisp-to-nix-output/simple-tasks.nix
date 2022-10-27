/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "simple-tasks";
  version = "20190710-git";

  description = "A very simple task scheduling framework.";

  deps = [ args."alexandria" args."array-utils" args."bordeaux-threads" args."dissect" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/simple-tasks/2019-07-10/simple-tasks-20190710-git.tgz";
    sha256 = "12y5phnbj9s2fsrz1ab6xj857zf1fv8kjk7jj2mdjs6k2d8gk8v3";
  };

  packageName = "simple-tasks";

  asdFilesToKeep = ["simple-tasks.asd"];
  overrides = x: x;
}
/* (SYSTEM simple-tasks DESCRIPTION A very simple task scheduling framework.
    SHA256 12y5phnbj9s2fsrz1ab6xj857zf1fv8kjk7jj2mdjs6k2d8gk8v3 URL
    http://beta.quicklisp.org/archive/simple-tasks/2019-07-10/simple-tasks-20190710-git.tgz
    MD5 8e88a9a762bc8691f92217d256baa55e NAME simple-tasks FILENAME
    simple-tasks DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME array-utils FILENAME array-utils)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME dissect FILENAME dissect))
    DEPENDENCIES (alexandria array-utils bordeaux-threads dissect) VERSION
    20190710-git SIBLINGS NIL PARASITES NIL) */
