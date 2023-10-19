/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "float-features";
  version = "20210228-git";

  description = "A portability library for IEEE float features not covered by the CL standard.";

  deps = [ args."documentation-utils" args."trivial-indent" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/float-features/2021-02-28/float-features-20210228-git.tgz";
    sha256 = "1giy9qm9bgdfp1mm4d36fcj544kfq68qckmijlrhwbvkpk18hgrd";
  };

  packageName = "float-features";

  asdFilesToKeep = ["float-features.asd"];
  overrides = x: x;
}
/* (SYSTEM float-features DESCRIPTION
    A portability library for IEEE float features not covered by the CL standard.
    SHA256 1giy9qm9bgdfp1mm4d36fcj544kfq68qckmijlrhwbvkpk18hgrd URL
    http://beta.quicklisp.org/archive/float-features/2021-02-28/float-features-20210228-git.tgz
    MD5 77223b9c85dca49d0f599e51ba95953a NAME float-features FILENAME
    float-features DEPS
    ((NAME documentation-utils FILENAME documentation-utils)
     (NAME trivial-indent FILENAME trivial-indent))
    DEPENDENCIES (documentation-utils trivial-indent) VERSION 20210228-git
    SIBLINGS (float-features-tests) PARASITES NIL) */
