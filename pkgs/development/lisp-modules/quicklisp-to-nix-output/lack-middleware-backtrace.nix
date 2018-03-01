args @ { fetchurl, ... }:
rec {
  baseName = ''lack-middleware-backtrace'';
  version = ''lack-20180131-git'';

  description = '''';

  deps = [ args."uiop" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/lack/2018-01-31/lack-20180131-git.tgz'';
    sha256 = ''17ydk90rjxjijc2r6kcwkbhh0l4a83xvhrbp0bc8wzbpkh2plywl'';
  };

  packageName = "lack-middleware-backtrace";

  asdFilesToKeep = ["lack-middleware-backtrace.asd"];
  overrides = x: x;
}
/* (SYSTEM lack-middleware-backtrace DESCRIPTION NIL SHA256
    17ydk90rjxjijc2r6kcwkbhh0l4a83xvhrbp0bc8wzbpkh2plywl URL
    http://beta.quicklisp.org/archive/lack/2018-01-31/lack-20180131-git.tgz MD5
    e1807a22a021ca27d8d1add9219091eb NAME lack-middleware-backtrace FILENAME
    lack-middleware-backtrace DEPS ((NAME uiop FILENAME uiop)) DEPENDENCIES
    (uiop) VERSION lack-20180131-git SIBLINGS
    (lack-component lack-middleware-accesslog lack-middleware-auth-basic
     lack-middleware-csrf lack-middleware-mount lack-middleware-session
     lack-middleware-static lack-request lack-response lack-session-store-dbi
     lack-session-store-redis lack-test lack-util-writer-stream lack-util lack
     t-lack-component t-lack-middleware-accesslog t-lack-middleware-auth-basic
     t-lack-middleware-backtrace t-lack-middleware-csrf t-lack-middleware-mount
     t-lack-middleware-session t-lack-middleware-static t-lack-request
     t-lack-session-store-dbi t-lack-session-store-redis t-lack-util t-lack)
    PARASITES NIL) */
