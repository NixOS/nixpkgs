args @ { fetchurl, ... }:
rec {
  baseName = ''lack'';
  version = ''20181210-git'';

  description = ''A minimal Clack'';

  deps = [ args."ironclad" args."lack-component" args."lack-util" args."nibbles" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/lack/2018-12-10/lack-20181210-git.tgz'';
    sha256 = ''00i36c5r5nk8abqqxhclr9nj6wawpybf5raswpm18h0kpxyf6qz8'';
  };

  packageName = "lack";

  asdFilesToKeep = ["lack.asd"];
  overrides = x: x;
}
/* (SYSTEM lack DESCRIPTION A minimal Clack SHA256
    00i36c5r5nk8abqqxhclr9nj6wawpybf5raswpm18h0kpxyf6qz8 URL
    http://beta.quicklisp.org/archive/lack/2018-12-10/lack-20181210-git.tgz MD5
    b75ab822b0b1d7fa5ff4d47db3ec80dd NAME lack FILENAME lack DEPS
    ((NAME ironclad FILENAME ironclad)
     (NAME lack-component FILENAME lack-component)
     (NAME lack-util FILENAME lack-util) (NAME nibbles FILENAME nibbles))
    DEPENDENCIES (ironclad lack-component lack-util nibbles) VERSION
    20181210-git SIBLINGS
    (lack-component lack-middleware-accesslog lack-middleware-auth-basic
     lack-middleware-backtrace lack-middleware-csrf lack-middleware-mount
     lack-middleware-session lack-middleware-static lack-request lack-response
     lack-session-store-dbi lack-session-store-redis lack-test
     lack-util-writer-stream lack-util t-lack-component
     t-lack-middleware-accesslog t-lack-middleware-auth-basic
     t-lack-middleware-backtrace t-lack-middleware-csrf t-lack-middleware-mount
     t-lack-middleware-session t-lack-middleware-static t-lack-request
     t-lack-session-store-dbi t-lack-session-store-redis t-lack-util t-lack)
    PARASITES NIL) */
