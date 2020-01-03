args @ { fetchurl, ... }:
rec {
  baseName = ''lquery'';
  version = ''20190710-git'';

  description = ''A library to allow jQuery-like HTML/DOM manipulation.'';

  deps = [ args."array-utils" args."clss" args."documentation-utils" args."form-fiddle" args."plump" args."trivial-indent" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/lquery/2019-07-10/lquery-20190710-git.tgz'';
    sha256 = ''17kgp8xrygg2d7pfzqram3iv3rry91yfgjs1ym37ac8r5gqrmfsw'';
  };

  packageName = "lquery";

  asdFilesToKeep = ["lquery.asd"];
  overrides = x: x;
}
/* (SYSTEM lquery DESCRIPTION
    A library to allow jQuery-like HTML/DOM manipulation. SHA256
    17kgp8xrygg2d7pfzqram3iv3rry91yfgjs1ym37ac8r5gqrmfsw URL
    http://beta.quicklisp.org/archive/lquery/2019-07-10/lquery-20190710-git.tgz
    MD5 987e9e505ff230c7bfc425bdf58fb717 NAME lquery FILENAME lquery DEPS
    ((NAME array-utils FILENAME array-utils) (NAME clss FILENAME clss)
     (NAME documentation-utils FILENAME documentation-utils)
     (NAME form-fiddle FILENAME form-fiddle) (NAME plump FILENAME plump)
     (NAME trivial-indent FILENAME trivial-indent))
    DEPENDENCIES
    (array-utils clss documentation-utils form-fiddle plump trivial-indent)
    VERSION 20190710-git SIBLINGS (lquery-test) PARASITES NIL) */
