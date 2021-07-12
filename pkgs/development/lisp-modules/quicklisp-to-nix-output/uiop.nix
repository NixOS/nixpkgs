/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "uiop";
  version = "3.3.4";

  description = "System lacks description";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/uiop/2020-02-18/uiop-3.3.4.tgz";
    sha256 = "0n0fp55ivwi6gzhaywdkngnk2snpp9nn3mz5rq3pnrwldi9q7aav";
  };

  packageName = "uiop";

  asdFilesToKeep = ["uiop.asd"];
  overrides = x: x;
}
/* (SYSTEM uiop DESCRIPTION System lacks description SHA256
    0n0fp55ivwi6gzhaywdkngnk2snpp9nn3mz5rq3pnrwldi9q7aav URL
    http://beta.quicklisp.org/archive/uiop/2020-02-18/uiop-3.3.4.tgz MD5
    b13a79a5aede43c97428c1cac86d6c2e NAME uiop FILENAME uiop DEPS NIL
    DEPENDENCIES NIL VERSION 3.3.4 SIBLINGS (asdf-driver) PARASITES NIL) */
