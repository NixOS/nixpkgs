/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "clunit";
  version = "20171019-git";

  description = "CLUnit is a Common Lisp unit testing framework.";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/clunit/2017-10-19/clunit-20171019-git.tgz";
    sha256 = "1rapyh0fbjnksj8j3y6imzya1kw80882w18j0fv9iq1hlp718zs5";
  };

  packageName = "clunit";

  asdFilesToKeep = ["clunit.asd"];
  overrides = x: x;
}
/* (SYSTEM clunit DESCRIPTION CLUnit is a Common Lisp unit testing framework.
    SHA256 1rapyh0fbjnksj8j3y6imzya1kw80882w18j0fv9iq1hlp718zs5 URL
    http://beta.quicklisp.org/archive/clunit/2017-10-19/clunit-20171019-git.tgz
    MD5 389017f2f05a6287078ddacd0471817e NAME clunit FILENAME clunit DEPS NIL
    DEPENDENCIES NIL VERSION 20171019-git SIBLINGS NIL PARASITES NIL) */
