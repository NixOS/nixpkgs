/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "lack-component";
  version = "lack-20201016-git";

  description = "System lacks description";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/lack/2020-10-16/lack-20201016-git.tgz";
    sha256 = "124c3k8116m5gc0rp4vvkqcvz35lglrbwdq4i929hbq65xyx5gan";
  };

  packageName = "lack-component";

  asdFilesToKeep = ["lack-component.asd"];
  overrides = x: x;
}
/* (SYSTEM lack-component DESCRIPTION System lacks description SHA256
    124c3k8116m5gc0rp4vvkqcvz35lglrbwdq4i929hbq65xyx5gan URL
    http://beta.quicklisp.org/archive/lack/2020-10-16/lack-20201016-git.tgz MD5
    8a056801bd99fdd70cdfaf33129f6aeb NAME lack-component FILENAME
    lack-component DEPS NIL DEPENDENCIES NIL VERSION lack-20201016-git SIBLINGS
    (lack-middleware-accesslog lack-middleware-auth-basic
     lack-middleware-backtrace lack-middleware-csrf lack-middleware-mount
     lack-middleware-session lack-middleware-static lack-request lack-response
     lack-session-store-dbi lack-session-store-redis lack-test
     lack-util-writer-stream lack-util lack t-lack-component
     t-lack-middleware-accesslog t-lack-middleware-auth-basic
     t-lack-middleware-backtrace t-lack-middleware-csrf t-lack-middleware-mount
     t-lack-middleware-session t-lack-middleware-static t-lack-request
     t-lack-session-store-dbi t-lack-session-store-redis t-lack-util t-lack)
    PARASITES NIL) */
