args @ { fetchurl, ... }:
rec {
  baseName = ''lack-middleware-backtrace'';
  version = ''lack-20181210-git'';

  description = '''';

  deps = [ args."uiop" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/lack/2018-12-10/lack-20181210-git.tgz'';
    sha256 = ''00i36c5r5nk8abqqxhclr9nj6wawpybf5raswpm18h0kpxyf6qz8'';
  };

  packageName = "lack-middleware-backtrace";

  asdFilesToKeep = ["lack-middleware-backtrace.asd"];
  overrides = x: x;
}
/* (SYSTEM lack-middleware-backtrace DESCRIPTION NIL SHA256
    00i36c5r5nk8abqqxhclr9nj6wawpybf5raswpm18h0kpxyf6qz8 URL
    http://beta.quicklisp.org/archive/lack/2018-12-10/lack-20181210-git.tgz MD5
    b75ab822b0b1d7fa5ff4d47db3ec80dd NAME lack-middleware-backtrace FILENAME
    lack-middleware-backtrace DEPS ((NAME uiop FILENAME uiop)) DEPENDENCIES
    (uiop) VERSION lack-20181210-git SIBLINGS
    (lack-component lack-middleware-accesslog lack-middleware-auth-basic
     lack-middleware-csrf lack-middleware-mount lack-middleware-session
     lack-middleware-static lack-request lack-response lack-session-store-dbi
     lack-session-store-redis lack-test lack-util-writer-stream lack-util lack
     t-lack-component t-lack-middleware-accesslog t-lack-middleware-auth-basic
     t-lack-middleware-backtrace t-lack-middleware-csrf t-lack-middleware-mount
     t-lack-middleware-session t-lack-middleware-static t-lack-request
     t-lack-session-store-dbi t-lack-session-store-redis t-lack-util t-lack)
    PARASITES NIL) */
