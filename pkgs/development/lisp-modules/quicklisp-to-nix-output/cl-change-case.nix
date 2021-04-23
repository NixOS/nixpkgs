/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-change-case";
  version = "20210228-git";

  parasites = [ "cl-change-case/test" ];

  description = "Convert strings between camelCase, param-case, PascalCase and more";

  deps = [ args."cl-ppcre" args."cl-ppcre-unicode" args."cl-unicode" args."fiveam" args."flexi-streams" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-change-case/2021-02-28/cl-change-case-20210228-git.tgz";
    sha256 = "15x8zxwa3pxs02fh0qxmbvz6vi59x6ha09p5hs4rgd6axs0k4pmi";
  };

  packageName = "cl-change-case";

  asdFilesToKeep = ["cl-change-case.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-change-case DESCRIPTION
    Convert strings between camelCase, param-case, PascalCase and more SHA256
    15x8zxwa3pxs02fh0qxmbvz6vi59x6ha09p5hs4rgd6axs0k4pmi URL
    http://beta.quicklisp.org/archive/cl-change-case/2021-02-28/cl-change-case-20210228-git.tgz
    MD5 8fec07f0634a739134dc4fcec807fe16 NAME cl-change-case FILENAME
    cl-change-case DEPS
    ((NAME cl-ppcre FILENAME cl-ppcre)
     (NAME cl-ppcre-unicode FILENAME cl-ppcre-unicode)
     (NAME cl-unicode FILENAME cl-unicode) (NAME fiveam FILENAME fiveam)
     (NAME flexi-streams FILENAME flexi-streams))
    DEPENDENCIES (cl-ppcre cl-ppcre-unicode cl-unicode fiveam flexi-streams)
    VERSION 20210228-git SIBLINGS NIL PARASITES (cl-change-case/test)) */
