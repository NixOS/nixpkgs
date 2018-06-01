args @ { fetchurl, ... }:
rec {
  baseName = ''fiasco'';
  version = ''20180228-git'';

  parasites = [ "fiasco-self-tests" ];

  description = ''A Common Lisp test framework that treasures your failures, logical continuation of Stefil.'';

  deps = [ args."alexandria" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/fiasco/2018-02-28/fiasco-20180228-git.tgz'';
    sha256 = ''0a67wvi5whmlw7kiv3b3rzy9kxn9m3135j9cnn92vads66adpxpy'';
  };

  packageName = "fiasco";

  asdFilesToKeep = ["fiasco.asd"];
  overrides = x: x;
}
/* (SYSTEM fiasco DESCRIPTION
    A Common Lisp test framework that treasures your failures, logical continuation of Stefil.
    SHA256 0a67wvi5whmlw7kiv3b3rzy9kxn9m3135j9cnn92vads66adpxpy URL
    http://beta.quicklisp.org/archive/fiasco/2018-02-28/fiasco-20180228-git.tgz
    MD5 a924e43c335836d2e44731dee6a1b8e6 NAME fiasco FILENAME fiasco DEPS
    ((NAME alexandria FILENAME alexandria)) DEPENDENCIES (alexandria) VERSION
    20180228-git SIBLINGS NIL PARASITES (fiasco-self-tests)) */
