/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "agutil";
  version = "20210531-git";

  description = "A collection of utility functions not found in other utility libraries.";

  deps = [ args."alexandria" args."closer-mop" args."optima" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/agutil/2021-05-31/agutil-20210531-git.tgz";
    sha256 = "01shs4qbr0bzmx9134cm84zbh8whbi2s5xngapd2fl8ag1rda9q1";
  };

  packageName = "agutil";

  asdFilesToKeep = ["agutil.asd"];
  overrides = x: x;
}
/* (SYSTEM agutil DESCRIPTION
    A collection of utility functions not found in other utility libraries.
    SHA256 01shs4qbr0bzmx9134cm84zbh8whbi2s5xngapd2fl8ag1rda9q1 URL
    http://beta.quicklisp.org/archive/agutil/2021-05-31/agutil-20210531-git.tgz
    MD5 99de7cd320ae2696c1707ca5b55cf40a NAME agutil FILENAME agutil DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME closer-mop FILENAME closer-mop) (NAME optima FILENAME optima))
    DEPENDENCIES (alexandria closer-mop optima) VERSION 20210531-git SIBLINGS
    NIL PARASITES NIL) */
