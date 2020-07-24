args @ { fetchurl, ... }:
rec {
  baseName = ''fiasco'';
  version = ''20191130-git'';

  parasites = [ "fiasco-self-tests" ];

  description = ''A Common Lisp test framework that treasures your failures, logical continuation of Stefil.'';

  deps = [ args."alexandria" args."trivial-gray-streams" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/fiasco/2019-11-30/fiasco-20191130-git.tgz'';
    sha256 = ''0jpxzrac8kzb34b9n5zyh3wcz0wghxd7pq8xwxp87yg6c3927sl0'';
  };

  packageName = "fiasco";

  asdFilesToKeep = ["fiasco.asd"];
  overrides = x: x;
}
/* (SYSTEM fiasco DESCRIPTION
    A Common Lisp test framework that treasures your failures, logical continuation of Stefil.
    SHA256 0jpxzrac8kzb34b9n5zyh3wcz0wghxd7pq8xwxp87yg6c3927sl0 URL
    http://beta.quicklisp.org/archive/fiasco/2019-11-30/fiasco-20191130-git.tgz
    MD5 235809b661c89fed1c4ca4ba3e4f3606 NAME fiasco FILENAME fiasco DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams))
    DEPENDENCIES (alexandria trivial-gray-streams) VERSION 20191130-git
    SIBLINGS NIL PARASITES (fiasco-self-tests)) */
