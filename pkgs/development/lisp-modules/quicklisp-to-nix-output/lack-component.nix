args @ { fetchurl, ... }:
rec {
  baseName = ''lack-component'';
  version = ''lack-20180430-git'';

  description = '''';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/lack/2018-04-30/lack-20180430-git.tgz'';
    sha256 = ''07f0nn1y8ghzg6s9rnmazaq3n7hr91mczdci5l3v4ncs79272h5v'';
  };

  packageName = "lack-component";

  asdFilesToKeep = ["lack-component.asd"];
  overrides = x: x;
}
/* (SYSTEM lack-component DESCRIPTION NIL SHA256
    07f0nn1y8ghzg6s9rnmazaq3n7hr91mczdci5l3v4ncs79272h5v URL
    http://beta.quicklisp.org/archive/lack/2018-04-30/lack-20180430-git.tgz MD5
    b9a0c08d54538679a8dd141022e8abb1 NAME lack-component FILENAME
    lack-component DEPS NIL DEPENDENCIES NIL VERSION lack-20180430-git SIBLINGS
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
