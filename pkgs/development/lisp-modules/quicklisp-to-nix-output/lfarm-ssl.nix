/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "lfarm-ssl";
  version = "lfarm-20150608-git";

  description = "SSL support for lfarm";

  deps = [ args."alexandria" args."babel" args."bordeaux-threads" args."cffi" args."cl_plus_ssl" args."cl-store" args."flexi-streams" args."lfarm-common" args."split-sequence" args."trivial-features" args."trivial-garbage" args."trivial-gray-streams" args."usocket" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/lfarm/2015-06-08/lfarm-20150608-git.tgz";
    sha256 = "1rkjcfam4601yczs13pi2qgi5jql0c150dxja53hkcnqhkyqgl66";
  };

  packageName = "lfarm-ssl";

  asdFilesToKeep = ["lfarm-ssl.asd"];
  overrides = x: x;
}
/* (SYSTEM lfarm-ssl DESCRIPTION SSL support for lfarm SHA256
    1rkjcfam4601yczs13pi2qgi5jql0c150dxja53hkcnqhkyqgl66 URL
    http://beta.quicklisp.org/archive/lfarm/2015-06-08/lfarm-20150608-git.tgz
    MD5 4cc91df44a932b3175a1eabf73d6e42d NAME lfarm-ssl FILENAME lfarm-ssl DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cffi FILENAME cffi) (NAME cl+ssl FILENAME cl_plus_ssl)
     (NAME cl-store FILENAME cl-store)
     (NAME flexi-streams FILENAME flexi-streams)
     (NAME lfarm-common FILENAME lfarm-common)
     (NAME split-sequence FILENAME split-sequence)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-garbage FILENAME trivial-garbage)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams)
     (NAME usocket FILENAME usocket))
    DEPENDENCIES
    (alexandria babel bordeaux-threads cffi cl+ssl cl-store flexi-streams
     lfarm-common split-sequence trivial-features trivial-garbage
     trivial-gray-streams usocket)
    VERSION lfarm-20150608-git SIBLINGS
    (lfarm-admin lfarm-client lfarm-common lfarm-gss lfarm-launcher
     lfarm-server lfarm-test)
    PARASITES NIL) */
