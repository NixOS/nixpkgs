args @ { fetchurl, ... }:
rec {
  baseName = ''woo'';
  version = ''20170725-git'';

  description = ''An asynchronous HTTP server written in Common Lisp'';

  deps = [ args."alexandria" args."babel" args."bordeaux-threads" args."cffi" args."cffi-grovel" args."cl-utilities" args."clack-socket" args."fast-http" args."fast-io" args."flexi-streams" args."lev" args."proc-parse" args."quri" args."smart-buffer" args."split-sequence" args."static-vectors" args."swap-bytes" args."trivial-features" args."trivial-gray-streams" args."trivial-utf-8" args."uiop" args."vom" args."xsubseq" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/woo/2017-07-25/woo-20170725-git.tgz'';
    sha256 = ''11cnqd058mjhkgxppsivbmd687429r4b62v7z5iav0wpha78qfgg'';
  };

  packageName = "woo";

  asdFilesToKeep = ["woo.asd"];
  overrides = x: x;
}
/* (SYSTEM woo DESCRIPTION An asynchronous HTTP server written in Common Lisp
    SHA256 11cnqd058mjhkgxppsivbmd687429r4b62v7z5iav0wpha78qfgg URL
    http://beta.quicklisp.org/archive/woo/2017-07-25/woo-20170725-git.tgz MD5
    bd901d8dfa7df3d19c6da73ea101f65b NAME woo FILENAME woo DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cffi FILENAME cffi) (NAME cffi-grovel FILENAME cffi-grovel)
     (NAME cl-utilities FILENAME cl-utilities)
     (NAME clack-socket FILENAME clack-socket)
     (NAME fast-http FILENAME fast-http) (NAME fast-io FILENAME fast-io)
     (NAME flexi-streams FILENAME flexi-streams) (NAME lev FILENAME lev)
     (NAME proc-parse FILENAME proc-parse) (NAME quri FILENAME quri)
     (NAME smart-buffer FILENAME smart-buffer)
     (NAME split-sequence FILENAME split-sequence)
     (NAME static-vectors FILENAME static-vectors)
     (NAME swap-bytes FILENAME swap-bytes)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams)
     (NAME trivial-utf-8 FILENAME trivial-utf-8) (NAME uiop FILENAME uiop)
     (NAME vom FILENAME vom) (NAME xsubseq FILENAME xsubseq))
    DEPENDENCIES
    (alexandria babel bordeaux-threads cffi cffi-grovel cl-utilities
     clack-socket fast-http fast-io flexi-streams lev proc-parse quri
     smart-buffer split-sequence static-vectors swap-bytes trivial-features
     trivial-gray-streams trivial-utf-8 uiop vom xsubseq)
    VERSION 20170725-git SIBLINGS (clack-handler-woo woo-test) PARASITES NIL) */
