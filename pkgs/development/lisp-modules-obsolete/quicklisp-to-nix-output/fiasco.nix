/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "fiasco";
  version = "20200610-git";

  parasites = [ "fiasco-self-tests" ];

  description = "A Common Lisp test framework that treasures your failures, logical continuation of Stefil.";

  deps = [ args."alexandria" args."trivial-gray-streams" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/fiasco/2020-06-10/fiasco-20200610-git.tgz";
    sha256 = "1wb0ibw6ka9fbsb40zjipn7vh3jbzyfsvcc9gq19nqhbqa8gy9r4";
  };

  packageName = "fiasco";

  asdFilesToKeep = ["fiasco.asd"];
  overrides = x: x;
}
/* (SYSTEM fiasco DESCRIPTION
    A Common Lisp test framework that treasures your failures, logical continuation of Stefil.
    SHA256 1wb0ibw6ka9fbsb40zjipn7vh3jbzyfsvcc9gq19nqhbqa8gy9r4 URL
    http://beta.quicklisp.org/archive/fiasco/2020-06-10/fiasco-20200610-git.tgz
    MD5 c5a84e4a0a8afe45729cd6e39af772ac NAME fiasco FILENAME fiasco DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams))
    DEPENDENCIES (alexandria trivial-gray-streams) VERSION 20200610-git
    SIBLINGS NIL PARASITES (fiasco-self-tests)) */
