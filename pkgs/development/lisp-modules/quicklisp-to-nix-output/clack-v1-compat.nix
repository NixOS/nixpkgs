args @ { fetchurl, ... }:
rec {
  baseName = ''clack-v1-compat'';
  version = ''clack-20170630-git'';

  description = '''';

  deps = [ args."alexandria" args."bordeaux-threads" args."circular-streams" args."cl-base64" args."cl-ppcre" args."cl-syntax-annot" args."clack" args."clack-test" args."dexador" args."flexi-streams" args."http-body" args."ironclad" args."lack" args."lack-util" args."local-time" args."marshal" args."prove" args."quri" args."split-sequence" args."trivial-backtrace" args."trivial-mimes" args."trivial-types" args."uiop" args."usocket" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/clack/2017-06-30/clack-20170630-git.tgz'';
    sha256 = ''1z3xrwldfzd4nagk2d0gw5hspnr35r6kh19ksqr3kyf6wpn2lybg'';
  };

  packageName = "clack-v1-compat";

  asdFilesToKeep = ["clack-v1-compat.asd"];
  overrides = x: x;
}
/* (SYSTEM clack-v1-compat DESCRIPTION NIL SHA256
    1z3xrwldfzd4nagk2d0gw5hspnr35r6kh19ksqr3kyf6wpn2lybg URL
    http://beta.quicklisp.org/archive/clack/2017-06-30/clack-20170630-git.tgz
    MD5 845b25a3cc6f3a1ee1dbd6de73dfb815 NAME clack-v1-compat FILENAME
    clack-v1-compat DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME circular-streams FILENAME circular-streams)
     (NAME cl-base64 FILENAME cl-base64) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME cl-syntax-annot FILENAME cl-syntax-annot)
     (NAME clack FILENAME clack) (NAME clack-test FILENAME clack-test)
     (NAME dexador FILENAME dexador)
     (NAME flexi-streams FILENAME flexi-streams)
     (NAME http-body FILENAME http-body) (NAME ironclad FILENAME ironclad)
     (NAME lack FILENAME lack) (NAME lack-util FILENAME lack-util)
     (NAME local-time FILENAME local-time) (NAME marshal FILENAME marshal)
     (NAME prove FILENAME prove) (NAME quri FILENAME quri)
     (NAME split-sequence FILENAME split-sequence)
     (NAME trivial-backtrace FILENAME trivial-backtrace)
     (NAME trivial-mimes FILENAME trivial-mimes)
     (NAME trivial-types FILENAME trivial-types) (NAME uiop FILENAME uiop)
     (NAME usocket FILENAME usocket))
    DEPENDENCIES
    (alexandria bordeaux-threads circular-streams cl-base64 cl-ppcre
     cl-syntax-annot clack clack-test dexador flexi-streams http-body ironclad
     lack lack-util local-time marshal prove quri split-sequence
     trivial-backtrace trivial-mimes trivial-types uiop usocket)
    VERSION clack-20170630-git SIBLINGS
    (clack-handler-fcgi clack-handler-hunchentoot clack-handler-toot
     clack-handler-wookie clack-socket clack-test clack t-clack-handler-fcgi
     t-clack-handler-hunchentoot t-clack-handler-toot t-clack-handler-wookie
     t-clack-v1-compat clack-middleware-auth-basic clack-middleware-clsql
     clack-middleware-csrf clack-middleware-dbi clack-middleware-oauth
     clack-middleware-postmodern clack-middleware-rucksack
     clack-session-store-dbi t-clack-middleware-auth-basic
     t-clack-middleware-csrf)
    PARASITES NIL) */
