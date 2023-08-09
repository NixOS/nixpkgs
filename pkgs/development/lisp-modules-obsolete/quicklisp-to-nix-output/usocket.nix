/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "usocket";
  version = "0.8.3";

  description = "Universal socket library for Common Lisp";

  deps = [ args."split-sequence" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/usocket/2019-12-27/usocket-0.8.3.tgz";
    sha256 = "19gl72r9jqms8slzn7i7bww2cqng9mhiqqhhccadlrx2xv6d3lm7";
  };

  packageName = "usocket";

  asdFilesToKeep = ["usocket.asd"];
  overrides = x: x;
}
/* (SYSTEM usocket DESCRIPTION Universal socket library for Common Lisp SHA256
    19gl72r9jqms8slzn7i7bww2cqng9mhiqqhhccadlrx2xv6d3lm7 URL
    http://beta.quicklisp.org/archive/usocket/2019-12-27/usocket-0.8.3.tgz MD5
    b1103034f32565487ab3b6eb92c0ca2b NAME usocket FILENAME usocket DEPS
    ((NAME split-sequence FILENAME split-sequence)) DEPENDENCIES
    (split-sequence) VERSION 0.8.3 SIBLINGS (usocket-server usocket-test)
    PARASITES NIL) */
