args @ { fetchurl, ... }:
{
  baseName = ''clss'';
  version = ''20190710-git'';

  description = ''A DOM tree searching engine based on CSS selectors.'';

  deps = [ args."array-utils" args."documentation-utils" args."plump" args."trivial-indent" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/clss/2019-07-10/clss-20190710-git.tgz'';
    sha256 = ''1gvnvwjrvinp8545gzav108pzrh00wx3vx2v7l6z18a80kn0h9vs'';
  };

  packageName = "clss";

  asdFilesToKeep = ["clss.asd"];
  overrides = x: x;
}
/* (SYSTEM clss DESCRIPTION A DOM tree searching engine based on CSS selectors.
    SHA256 1gvnvwjrvinp8545gzav108pzrh00wx3vx2v7l6z18a80kn0h9vs URL
    http://beta.quicklisp.org/archive/clss/2019-07-10/clss-20190710-git.tgz MD5
    c5a918fe272b71af7c4b6e71a7faad46 NAME clss FILENAME clss DEPS
    ((NAME array-utils FILENAME array-utils)
     (NAME documentation-utils FILENAME documentation-utils)
     (NAME plump FILENAME plump) (NAME trivial-indent FILENAME trivial-indent))
    DEPENDENCIES (array-utils documentation-utils plump trivial-indent) VERSION
    20190710-git SIBLINGS NIL PARASITES NIL) */
