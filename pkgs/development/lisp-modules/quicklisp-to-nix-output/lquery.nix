args @ { fetchurl, ... }:
rec {
  baseName = ''lquery'';
  version = ''20200715-git'';

  description = ''A library to allow jQuery-like HTML/DOM manipulation.'';

  deps = [ args."array-utils" args."clss" args."documentation-utils" args."form-fiddle" args."plump" args."trivial-indent" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/lquery/2020-07-15/lquery-20200715-git.tgz'';
    sha256 = ''1akj9yzz71733yfbqq9jig0zkx8brphzh35d8zzic0469idd3rcd'';
  };

  packageName = "lquery";

  asdFilesToKeep = ["lquery.asd"];
  overrides = x: x;
}
/* (SYSTEM lquery DESCRIPTION
    A library to allow jQuery-like HTML/DOM manipulation. SHA256
    1akj9yzz71733yfbqq9jig0zkx8brphzh35d8zzic0469idd3rcd URL
    http://beta.quicklisp.org/archive/lquery/2020-07-15/lquery-20200715-git.tgz
    MD5 38e282ac02c6a1ce9bc28bd9c1deee34 NAME lquery FILENAME lquery DEPS
    ((NAME array-utils FILENAME array-utils) (NAME clss FILENAME clss)
     (NAME documentation-utils FILENAME documentation-utils)
     (NAME form-fiddle FILENAME form-fiddle) (NAME plump FILENAME plump)
     (NAME trivial-indent FILENAME trivial-indent))
    DEPENDENCIES
    (array-utils clss documentation-utils form-fiddle plump trivial-indent)
    VERSION 20200715-git SIBLINGS (lquery-test) PARASITES NIL) */
