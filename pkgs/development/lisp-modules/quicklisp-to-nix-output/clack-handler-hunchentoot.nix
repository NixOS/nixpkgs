args @ { fetchurl, ... }:
rec {
  baseName = ''clack-handler-hunchentoot'';
  version = ''clack-20181018-git'';

  description = ''Clack handler for Hunchentoot.'';

  deps = [ args."alexandria" args."babel" args."bordeaux-threads" args."cffi" args."chunga" args."cl_plus_ssl" args."cl-base64" args."cl-fad" args."cl-ppcre" args."clack-socket" args."flexi-streams" args."hunchentoot" args."md5" args."rfc2388" args."split-sequence" args."trivial-backtrace" args."trivial-features" args."trivial-garbage" args."trivial-gray-streams" args."usocket" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/clack/2018-10-18/clack-20181018-git.tgz'';
    sha256 = ''1f16i1pdqkh56ahnhxni3182q089d7ya8gxv4vyczsjzw93yakcf'';
  };

  packageName = "clack-handler-hunchentoot";

  asdFilesToKeep = ["clack-handler-hunchentoot.asd"];
  overrides = x: x;
}
/* (SYSTEM clack-handler-hunchentoot DESCRIPTION Clack handler for Hunchentoot.
    SHA256 1f16i1pdqkh56ahnhxni3182q089d7ya8gxv4vyczsjzw93yakcf URL
    http://beta.quicklisp.org/archive/clack/2018-10-18/clack-20181018-git.tgz
    MD5 16121d921667ee8d0d70324da7281849 NAME clack-handler-hunchentoot
    FILENAME clack-handler-hunchentoot DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cffi FILENAME cffi) (NAME chunga FILENAME chunga)
     (NAME cl+ssl FILENAME cl_plus_ssl) (NAME cl-base64 FILENAME cl-base64)
     (NAME cl-fad FILENAME cl-fad) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME clack-socket FILENAME clack-socket)
     (NAME flexi-streams FILENAME flexi-streams)
     (NAME hunchentoot FILENAME hunchentoot) (NAME md5 FILENAME md5)
     (NAME rfc2388 FILENAME rfc2388)
     (NAME split-sequence FILENAME split-sequence)
     (NAME trivial-backtrace FILENAME trivial-backtrace)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-garbage FILENAME trivial-garbage)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams)
     (NAME usocket FILENAME usocket))
    DEPENDENCIES
    (alexandria babel bordeaux-threads cffi chunga cl+ssl cl-base64 cl-fad
     cl-ppcre clack-socket flexi-streams hunchentoot md5 rfc2388 split-sequence
     trivial-backtrace trivial-features trivial-garbage trivial-gray-streams
     usocket)
    VERSION clack-20181018-git SIBLINGS
    (clack-handler-fcgi clack-handler-toot clack-handler-wookie clack-socket
     clack-test clack-v1-compat clack t-clack-handler-fcgi
     t-clack-handler-hunchentoot t-clack-handler-toot t-clack-handler-wookie
     t-clack-v1-compat clack-middleware-auth-basic clack-middleware-clsql
     clack-middleware-csrf clack-middleware-dbi clack-middleware-oauth
     clack-middleware-postmodern clack-middleware-rucksack
     clack-session-store-dbi t-clack-middleware-auth-basic
     t-clack-middleware-csrf)
    PARASITES NIL) */
