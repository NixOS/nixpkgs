/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "lift";
  version = "20190521-git";

  description = "LIsp Framework for Testing";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/lift/2019-05-21/lift-20190521-git.tgz";
    sha256 = "0cinilin9bxzsj3mzd4488zx2irvyl5qpbykv0xbyfz2mjh94ac9";
  };

  packageName = "lift";

  asdFilesToKeep = ["lift.asd"];
  overrides = x: x;
}
/* (SYSTEM lift DESCRIPTION LIsp Framework for Testing SHA256
    0cinilin9bxzsj3mzd4488zx2irvyl5qpbykv0xbyfz2mjh94ac9 URL
    http://beta.quicklisp.org/archive/lift/2019-05-21/lift-20190521-git.tgz MD5
    c03d3fa715792440c7b51a852ad581e3 NAME lift FILENAME lift DEPS NIL
    DEPENDENCIES NIL VERSION 20190521-git SIBLINGS
    (lift-documentation lift-test) PARASITES NIL) */
