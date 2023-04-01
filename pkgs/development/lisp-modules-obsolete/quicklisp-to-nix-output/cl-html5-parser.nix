/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-html5-parser";
  version = "20190521-git";

  description = "A HTML5 parser for Common Lisp";

  deps = [ args."cl-ppcre" args."flexi-streams" args."string-case" args."trivial-gray-streams" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-html5-parser/2019-05-21/cl-html5-parser-20190521-git.tgz";
    sha256 = "055jz0yqgjncvy2dxvnwg4iwdvmfsvkch46v58nymz5gi8gaaz7p";
  };

  packageName = "cl-html5-parser";

  asdFilesToKeep = ["cl-html5-parser.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-html5-parser DESCRIPTION A HTML5 parser for Common Lisp SHA256
    055jz0yqgjncvy2dxvnwg4iwdvmfsvkch46v58nymz5gi8gaaz7p URL
    http://beta.quicklisp.org/archive/cl-html5-parser/2019-05-21/cl-html5-parser-20190521-git.tgz
    MD5 149e5609d0a96c867fac6c22693c5e30 NAME cl-html5-parser FILENAME
    cl-html5-parser DEPS
    ((NAME cl-ppcre FILENAME cl-ppcre)
     (NAME flexi-streams FILENAME flexi-streams)
     (NAME string-case FILENAME string-case)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams))
    DEPENDENCIES (cl-ppcre flexi-streams string-case trivial-gray-streams)
    VERSION 20190521-git SIBLINGS (cl-html5-parser-cxml cl-html5-parser-tests)
    PARASITES NIL) */
