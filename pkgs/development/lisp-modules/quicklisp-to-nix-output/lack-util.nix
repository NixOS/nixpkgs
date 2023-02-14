/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "lack-util";
  version = "lack-20220220-git";

  description = "System lacks description";

  deps = [ args."cl-isaac" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/lack/2022-02-20/lack-20220220-git.tgz";
    sha256 = "122k2jknsgvca22g0jq1bd881d64b6fiaprbzsbf67gjaf2djmn1";
  };

  packageName = "lack-util";

  asdFilesToKeep = ["lack-util.asd"];
  overrides = x: x;
}
/* (SYSTEM lack-util DESCRIPTION System lacks description SHA256
    122k2jknsgvca22g0jq1bd881d64b6fiaprbzsbf67gjaf2djmn1 URL
    http://beta.quicklisp.org/archive/lack/2022-02-20/lack-20220220-git.tgz MD5
    3dd95bf5e8ed28862b2390ee64dd33e5 NAME lack-util FILENAME lack-util DEPS
    ((NAME cl-isaac FILENAME cl-isaac)) DEPENDENCIES (cl-isaac) VERSION
    lack-20220220-git SIBLINGS
    (lack-app-directory lack-app-file lack-component lack-middleware-accesslog
     lack-middleware-auth-basic lack-middleware-backtrace lack-middleware-csrf
     lack-middleware-mount lack-middleware-session lack-middleware-static
     lack-request lack-response lack-session-store-dbi lack-session-store-redis
     lack-test lack-util-writer-stream lack t-lack-component
     t-lack-middleware-accesslog t-lack-middleware-auth-basic
     t-lack-middleware-backtrace t-lack-middleware-csrf t-lack-middleware-mount
     t-lack-middleware-session t-lack-middleware-static t-lack-request
     t-lack-session-store-dbi t-lack-session-store-redis t-lack-util t-lack)
    PARASITES NIL) */
