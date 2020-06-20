args @ { fetchurl, ... }:
rec {
  baseName = ''clss'';
  version = ''20191130-git'';

  description = ''A DOM tree searching engine based on CSS selectors.'';

  deps = [ args."array-utils" args."documentation-utils" args."plump" args."trivial-indent" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/clss/2019-11-30/clss-20191130-git.tgz'';
    sha256 = ''0cbjzsc90fpa8zqv5s0ri7ncbv6f8azgbbfsxswqfphbibkcpcka'';
  };

  packageName = "clss";

  asdFilesToKeep = ["clss.asd"];
  overrides = x: x;
}
/* (SYSTEM clss DESCRIPTION A DOM tree searching engine based on CSS selectors.
    SHA256 0cbjzsc90fpa8zqv5s0ri7ncbv6f8azgbbfsxswqfphbibkcpcka URL
    http://beta.quicklisp.org/archive/clss/2019-11-30/clss-20191130-git.tgz MD5
    9910677b36df00f3046905a9b84122a9 NAME clss FILENAME clss DEPS
    ((NAME array-utils FILENAME array-utils)
     (NAME documentation-utils FILENAME documentation-utils)
     (NAME plump FILENAME plump) (NAME trivial-indent FILENAME trivial-indent))
    DEPENDENCIES (array-utils documentation-utils plump trivial-indent) VERSION
    20191130-git SIBLINGS NIL PARASITES NIL) */
