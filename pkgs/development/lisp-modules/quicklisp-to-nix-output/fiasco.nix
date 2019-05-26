args @ { fetchurl, ... }:
rec {
  baseName = ''fiasco'';
  version = ''20181210-git'';

  parasites = [ "fiasco-self-tests" ];

  description = ''A Common Lisp test framework that treasures your failures, logical continuation of Stefil.'';

  deps = [ args."alexandria" args."trivial-gray-streams" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/fiasco/2018-12-10/fiasco-20181210-git.tgz'';
    sha256 = ''0l4wjik8iwipy67lbdrjhcvz7zldv85nykbxasis4zmmh001777y'';
  };

  packageName = "fiasco";

  asdFilesToKeep = ["fiasco.asd"];
  overrides = x: x;
}
/* (SYSTEM fiasco DESCRIPTION
    A Common Lisp test framework that treasures your failures, logical continuation of Stefil.
    SHA256 0l4wjik8iwipy67lbdrjhcvz7zldv85nykbxasis4zmmh001777y URL
    http://beta.quicklisp.org/archive/fiasco/2018-12-10/fiasco-20181210-git.tgz
    MD5 9d3c0ec30c7f73490188f27eaec00fd8 NAME fiasco FILENAME fiasco DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams))
    DEPENDENCIES (alexandria trivial-gray-streams) VERSION 20181210-git
    SIBLINGS NIL PARASITES (fiasco-self-tests)) */
