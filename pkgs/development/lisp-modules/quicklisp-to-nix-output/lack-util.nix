/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "lack-util";
  version = "lack-20210807-git";

  description = "System lacks description";

  deps = [ args."alexandria" args."bordeaux-threads" args."ironclad" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/lack/2021-08-07/lack-20210807-git.tgz";
    sha256 = "0zyyr9wkncf03l4jf54mkjm4kaiswmwj5y198kp9v00x2ljjnkjn";
  };

  packageName = "lack-util";

  asdFilesToKeep = ["lack-util.asd"];
  overrides = x: x;
}
/* (SYSTEM lack-util DESCRIPTION System lacks description SHA256
    0zyyr9wkncf03l4jf54mkjm4kaiswmwj5y198kp9v00x2ljjnkjn URL
    http://beta.quicklisp.org/archive/lack/2021-08-07/lack-20210807-git.tgz MD5
    76b3ab979e6c3d7d33dd2fd3864692ca NAME lack-util FILENAME lack-util DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME ironclad FILENAME ironclad))
    DEPENDENCIES (alexandria bordeaux-threads ironclad) VERSION
    lack-20210807-git SIBLINGS
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
