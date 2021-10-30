/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "lack-middleware-backtrace";
  version = "lack-20211020-git";

  description = "System lacks description";

  deps = [ args."uiop" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/lack/2021-10-20/lack-20211020-git.tgz";
    sha256 = "0ly7bdvrl5xsls9syybcf0qm2981m434rhr3gr756kvvk4s9mdn2";
  };

  packageName = "lack-middleware-backtrace";

  asdFilesToKeep = ["lack-middleware-backtrace.asd"];
  overrides = x: x;
}
/* (SYSTEM lack-middleware-backtrace DESCRIPTION System lacks description
    SHA256 0ly7bdvrl5xsls9syybcf0qm2981m434rhr3gr756kvvk4s9mdn2 URL
    http://beta.quicklisp.org/archive/lack/2021-10-20/lack-20211020-git.tgz MD5
    4a98955fb9cd5db45b796a0b269a57e1 NAME lack-middleware-backtrace FILENAME
    lack-middleware-backtrace DEPS ((NAME uiop FILENAME uiop)) DEPENDENCIES
    (uiop) VERSION lack-20211020-git SIBLINGS
    (lack-app-directory lack-app-file lack-component lack-middleware-accesslog
     lack-middleware-auth-basic lack-middleware-csrf lack-middleware-mount
     lack-middleware-session lack-middleware-static lack-request lack-response
     lack-session-store-dbi lack-session-store-redis lack-test
     lack-util-writer-stream lack-util lack t-lack-component
     t-lack-middleware-accesslog t-lack-middleware-auth-basic
     t-lack-middleware-backtrace t-lack-middleware-csrf t-lack-middleware-mount
     t-lack-middleware-session t-lack-middleware-static t-lack-request
     t-lack-session-store-dbi t-lack-session-store-redis t-lack-util t-lack)
    PARASITES NIL) */
