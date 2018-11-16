args @ { fetchurl, ... }:
rec {
  baseName = ''lack-util'';
  version = ''lack-20180831-git'';

  description = '''';

  deps = [ args."ironclad" args."nibbles" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/lack/2018-08-31/lack-20180831-git.tgz'';
    sha256 = ''0x4b3v5qvrik5c8nn4kpxygv78srqb306jcypkhpyc65ig81gr9n'';
  };

  packageName = "lack-util";

  asdFilesToKeep = ["lack-util.asd"];
  overrides = x: x;
}
/* (SYSTEM lack-util DESCRIPTION NIL SHA256
    0x4b3v5qvrik5c8nn4kpxygv78srqb306jcypkhpyc65ig81gr9n URL
    http://beta.quicklisp.org/archive/lack/2018-08-31/lack-20180831-git.tgz MD5
    fd57a7185997a1a5f37bbd9d6899118d NAME lack-util FILENAME lack-util DEPS
    ((NAME ironclad FILENAME ironclad) (NAME nibbles FILENAME nibbles))
    DEPENDENCIES (ironclad nibbles) VERSION lack-20180831-git SIBLINGS
    (lack-component lack-middleware-accesslog lack-middleware-auth-basic
     lack-middleware-backtrace lack-middleware-csrf lack-middleware-mount
     lack-middleware-session lack-middleware-static lack-request lack-response
     lack-session-store-dbi lack-session-store-redis lack-test
     lack-util-writer-stream lack t-lack-component t-lack-middleware-accesslog
     t-lack-middleware-auth-basic t-lack-middleware-backtrace
     t-lack-middleware-csrf t-lack-middleware-mount t-lack-middleware-session
     t-lack-middleware-static t-lack-request t-lack-session-store-dbi
     t-lack-session-store-redis t-lack-util t-lack)
    PARASITES NIL) */
