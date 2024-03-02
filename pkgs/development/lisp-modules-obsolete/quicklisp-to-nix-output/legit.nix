/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "legit";
  version = "20190710-git";

  description = "CL interface to the GIT binary.";

  deps = [ args."alexandria" args."bordeaux-threads" args."cl-ppcre" args."documentation-utils" args."lambda-fiddle" args."simple-inferiors" args."trivial-indent" args."uiop" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/legit/2019-07-10/legit-20190710-git.tgz";
    sha256 = "0g7cn50qvivsn0w9yszqw2qh22jsj60067pmg5pvwsjm03xdl9s9";
  };

  packageName = "legit";

  asdFilesToKeep = ["legit.asd"];
  overrides = x: x;
}
/* (SYSTEM legit DESCRIPTION CL interface to the GIT binary. SHA256
    0g7cn50qvivsn0w9yszqw2qh22jsj60067pmg5pvwsjm03xdl9s9 URL
    http://beta.quicklisp.org/archive/legit/2019-07-10/legit-20190710-git.tgz
    MD5 9b380fc23d4bab086df8a0e4a598457a NAME legit FILENAME legit DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME documentation-utils FILENAME documentation-utils)
     (NAME lambda-fiddle FILENAME lambda-fiddle)
     (NAME simple-inferiors FILENAME simple-inferiors)
     (NAME trivial-indent FILENAME trivial-indent) (NAME uiop FILENAME uiop))
    DEPENDENCIES
    (alexandria bordeaux-threads cl-ppcre documentation-utils lambda-fiddle
     simple-inferiors trivial-indent uiop)
    VERSION 20190710-git SIBLINGS NIL PARASITES NIL) */
