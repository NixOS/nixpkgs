args @ { fetchurl, ... }:
rec {
  baseName = ''lquery'';
  version = ''20180831-git'';

  description = ''A library to allow jQuery-like HTML/DOM manipulation.'';

  deps = [ args."array-utils" args."clss" args."documentation-utils" args."form-fiddle" args."plump" args."trivial-indent" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/lquery/2018-08-31/lquery-20180831-git.tgz'';
    sha256 = ''1nb2hvcw043qlqxch7lky67k0r9gxjwaggkm8hfznlijbkgbfy2v'';
  };

  packageName = "lquery";

  asdFilesToKeep = ["lquery.asd"];
  overrides = x: x;
}
/* (SYSTEM lquery DESCRIPTION
    A library to allow jQuery-like HTML/DOM manipulation. SHA256
    1nb2hvcw043qlqxch7lky67k0r9gxjwaggkm8hfznlijbkgbfy2v URL
    http://beta.quicklisp.org/archive/lquery/2018-08-31/lquery-20180831-git.tgz
    MD5 d0d3efa47f151afeb754c4bc0c059acf NAME lquery FILENAME lquery DEPS
    ((NAME array-utils FILENAME array-utils) (NAME clss FILENAME clss)
     (NAME documentation-utils FILENAME documentation-utils)
     (NAME form-fiddle FILENAME form-fiddle) (NAME plump FILENAME plump)
     (NAME trivial-indent FILENAME trivial-indent))
    DEPENDENCIES
    (array-utils clss documentation-utils form-fiddle plump trivial-indent)
    VERSION 20180831-git SIBLINGS (lquery-test) PARASITES NIL) */
