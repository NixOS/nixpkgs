args @ { fetchurl, ... }:
rec {
  baseName = ''lquery'';
  version = ''20190107-git'';

  description = ''A library to allow jQuery-like HTML/DOM manipulation.'';

  deps = [ args."array-utils" args."clss" args."documentation-utils" args."form-fiddle" args."plump" args."trivial-indent" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/lquery/2019-01-07/lquery-20190107-git.tgz'';
    sha256 = ''023w4hsclqhw9bg1rfva0sapqmnmgsvf9gngbfhqcfgsdf7wff9r'';
  };

  packageName = "lquery";

  asdFilesToKeep = ["lquery.asd"];
  overrides = x: x;
}
/* (SYSTEM lquery DESCRIPTION
    A library to allow jQuery-like HTML/DOM manipulation. SHA256
    023w4hsclqhw9bg1rfva0sapqmnmgsvf9gngbfhqcfgsdf7wff9r URL
    http://beta.quicklisp.org/archive/lquery/2019-01-07/lquery-20190107-git.tgz
    MD5 295245984aa471d2709dcf926abd82e2 NAME lquery FILENAME lquery DEPS
    ((NAME array-utils FILENAME array-utils) (NAME clss FILENAME clss)
     (NAME documentation-utils FILENAME documentation-utils)
     (NAME form-fiddle FILENAME form-fiddle) (NAME plump FILENAME plump)
     (NAME trivial-indent FILENAME trivial-indent))
    DEPENDENCIES
    (array-utils clss documentation-utils form-fiddle plump trivial-indent)
    VERSION 20190107-git SIBLINGS (lquery-test) PARASITES NIL) */
