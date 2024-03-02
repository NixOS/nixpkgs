/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "lfarm-client";
  version = "lfarm-20150608-git";

  description = "Client component of lfarm, a library for distributing work across machines.";

  deps = [ args."alexandria" args."bordeaux-threads" args."cl-store" args."flexi-streams" args."lfarm-common" args."lparallel" args."split-sequence" args."trivial-gray-streams" args."usocket" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/lfarm/2015-06-08/lfarm-20150608-git.tgz";
    sha256 = "1rkjcfam4601yczs13pi2qgi5jql0c150dxja53hkcnqhkyqgl66";
  };

  packageName = "lfarm-client";

  asdFilesToKeep = ["lfarm-client.asd"];
  overrides = x: x;
}
/* (SYSTEM lfarm-client DESCRIPTION
    Client component of lfarm, a library for distributing work across machines.
    SHA256 1rkjcfam4601yczs13pi2qgi5jql0c150dxja53hkcnqhkyqgl66 URL
    http://beta.quicklisp.org/archive/lfarm/2015-06-08/lfarm-20150608-git.tgz
    MD5 4cc91df44a932b3175a1eabf73d6e42d NAME lfarm-client FILENAME
    lfarm-client DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cl-store FILENAME cl-store)
     (NAME flexi-streams FILENAME flexi-streams)
     (NAME lfarm-common FILENAME lfarm-common)
     (NAME lparallel FILENAME lparallel)
     (NAME split-sequence FILENAME split-sequence)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams)
     (NAME usocket FILENAME usocket))
    DEPENDENCIES
    (alexandria bordeaux-threads cl-store flexi-streams lfarm-common lparallel
     split-sequence trivial-gray-streams usocket)
    VERSION lfarm-20150608-git SIBLINGS
    (lfarm-admin lfarm-common lfarm-gss lfarm-launcher lfarm-server lfarm-ssl
     lfarm-test)
    PARASITES NIL) */
