args @ { fetchurl, ... }:
{
  baseName = ''fiasco'';
  version = ''20190307-git'';

  parasites = [ "fiasco-self-tests" ];

  description = ''A Common Lisp test framework that treasures your failures, logical continuation of Stefil.'';

  deps = [ args."alexandria" args."trivial-gray-streams" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/fiasco/2019-03-07/fiasco-20190307-git.tgz'';
    sha256 = ''0ffnkfnj4ayvzsxb2h04xaypgxg3fbar07f6rvlbncdckm9q5jk3'';
  };

  packageName = "fiasco";

  asdFilesToKeep = ["fiasco.asd"];
  overrides = x: x;
}
/* (SYSTEM fiasco DESCRIPTION
    A Common Lisp test framework that treasures your failures, logical continuation of Stefil.
    SHA256 0ffnkfnj4ayvzsxb2h04xaypgxg3fbar07f6rvlbncdckm9q5jk3 URL
    http://beta.quicklisp.org/archive/fiasco/2019-03-07/fiasco-20190307-git.tgz
    MD5 7cc0c66f865d44974c8d682346b5f6d5 NAME fiasco FILENAME fiasco DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams))
    DEPENDENCIES (alexandria trivial-gray-streams) VERSION 20190307-git
    SIBLINGS NIL PARASITES (fiasco-self-tests)) */
