/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "lack-util";
  version = "lack-20201016-git";

  description = "System lacks description";

  deps = [ args."alexandria" args."bordeaux-threads" args."ironclad" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/lack/2020-10-16/lack-20201016-git.tgz";
    sha256 = "124c3k8116m5gc0rp4vvkqcvz35lglrbwdq4i929hbq65xyx5gan";
  };

  packageName = "lack-util";

  asdFilesToKeep = ["lack-util.asd"];
  overrides = x: x;
}
/* (SYSTEM lack-util DESCRIPTION System lacks description SHA256
    124c3k8116m5gc0rp4vvkqcvz35lglrbwdq4i929hbq65xyx5gan URL
    http://beta.quicklisp.org/archive/lack/2020-10-16/lack-20201016-git.tgz MD5
    8a056801bd99fdd70cdfaf33129f6aeb NAME lack-util FILENAME lack-util DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME ironclad FILENAME ironclad))
    DEPENDENCIES (alexandria bordeaux-threads ironclad) VERSION
    lack-20201016-git SIBLINGS
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
