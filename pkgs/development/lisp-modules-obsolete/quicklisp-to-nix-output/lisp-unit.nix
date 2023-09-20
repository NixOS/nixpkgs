/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "lisp-unit";
  version = "20170124-git";

  description = "Common Lisp library that supports unit testing.";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/lisp-unit/2017-01-24/lisp-unit-20170124-git.tgz";
    sha256 = "00bc19r7vr76rpk8lh8z7qln0glpf66mzqxw215488zwz3nwcq4m";
  };

  packageName = "lisp-unit";

  asdFilesToKeep = ["lisp-unit.asd"];
  overrides = x: x;
}
/* (SYSTEM lisp-unit DESCRIPTION
    Common Lisp library that supports unit testing. SHA256
    00bc19r7vr76rpk8lh8z7qln0glpf66mzqxw215488zwz3nwcq4m URL
    http://beta.quicklisp.org/archive/lisp-unit/2017-01-24/lisp-unit-20170124-git.tgz
    MD5 2c55342cb8af18b290bb6a28c75deac5 NAME lisp-unit FILENAME lisp-unit DEPS
    NIL DEPENDENCIES NIL VERSION 20170124-git SIBLINGS NIL PARASITES NIL) */
