/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "usocket-server";
  version = "usocket-0.8.3";

  description = "Universal socket library for Common Lisp (server side)";

  deps = [ args."alexandria" args."bordeaux-threads" args."split-sequence" args."usocket" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/usocket/2019-12-27/usocket-0.8.3.tgz";
    sha256 = "19gl72r9jqms8slzn7i7bww2cqng9mhiqqhhccadlrx2xv6d3lm7";
  };

  packageName = "usocket-server";

  asdFilesToKeep = ["usocket-server.asd"];
  overrides = x: x;
}
/* (SYSTEM usocket-server DESCRIPTION
    Universal socket library for Common Lisp (server side) SHA256
    19gl72r9jqms8slzn7i7bww2cqng9mhiqqhhccadlrx2xv6d3lm7 URL
    http://beta.quicklisp.org/archive/usocket/2019-12-27/usocket-0.8.3.tgz MD5
    b1103034f32565487ab3b6eb92c0ca2b NAME usocket-server FILENAME
    usocket-server DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME split-sequence FILENAME split-sequence)
     (NAME usocket FILENAME usocket))
    DEPENDENCIES (alexandria bordeaux-threads split-sequence usocket) VERSION
    usocket-0.8.3 SIBLINGS (usocket-test usocket) PARASITES NIL) */
