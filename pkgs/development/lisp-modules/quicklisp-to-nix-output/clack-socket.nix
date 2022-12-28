/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "clack-socket";
  version = "clack-20211209-git";

  description = "System lacks description";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/clack/2021-12-09/clack-20211209-git.tgz";
    sha256 = "1gp323083ds89cw3vd6w40d4cwx04y0qaqdz4wx2332klhvvdnsd";
  };

  packageName = "clack-socket";

  asdFilesToKeep = ["clack-socket.asd"];
  overrides = x: x;
}
/* (SYSTEM clack-socket DESCRIPTION System lacks description SHA256
    1gp323083ds89cw3vd6w40d4cwx04y0qaqdz4wx2332klhvvdnsd URL
    http://beta.quicklisp.org/archive/clack/2021-12-09/clack-20211209-git.tgz
    MD5 c223a854a79b257e0489e185abe48e16 NAME clack-socket FILENAME
    clack-socket DEPS NIL DEPENDENCIES NIL VERSION clack-20211209-git SIBLINGS
    (clack-handler-fcgi clack-handler-hunchentoot clack-handler-toot
     clack-handler-wookie clack-test clack t-clack-handler-fcgi
     t-clack-handler-hunchentoot t-clack-handler-toot t-clack-handler-wookie)
    PARASITES NIL) */
