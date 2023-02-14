/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "legit";
  version = "20211020-git";

  description = "CL interface to the GIT binary.";

  deps = [ args."alexandria" args."bordeaux-threads" args."cl-ppcre" args."documentation-utils" args."lambda-fiddle" args."simple-inferiors" args."trivial-indent" args."uiop" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/legit/2021-10-20/legit-20211020-git.tgz";
    sha256 = "01a5l7haj3bg176iwxqzzkwx090l8qrl0ni9x64fdgg75dh2m43l";
  };

  packageName = "legit";

  asdFilesToKeep = ["legit.asd"];
  overrides = x: x;
}
/* (SYSTEM legit DESCRIPTION CL interface to the GIT binary. SHA256
    01a5l7haj3bg176iwxqzzkwx090l8qrl0ni9x64fdgg75dh2m43l URL
    http://beta.quicklisp.org/archive/legit/2021-10-20/legit-20211020-git.tgz
    MD5 1d8531d126b10a1ed6bdec81179f9472 NAME legit FILENAME legit DEPS
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
    VERSION 20211020-git SIBLINGS NIL PARASITES NIL) */
