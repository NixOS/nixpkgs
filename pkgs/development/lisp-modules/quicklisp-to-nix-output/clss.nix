args @ { fetchurl, ... }:
rec {
  baseName = ''clss'';
  version = ''20180831-git'';

  description = ''A DOM tree searching engine based on CSS selectors.'';

  deps = [ args."array-utils" args."documentation-utils" args."plump" args."trivial-indent" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/clss/2018-08-31/clss-20180831-git.tgz'';
    sha256 = ''18jm89i9353khrp9q92bnqllkypcsmyd43jvdr6gl0n50fmzs5jd'';
  };

  packageName = "clss";

  asdFilesToKeep = ["clss.asd"];
  overrides = x: x;
}
/* (SYSTEM clss DESCRIPTION A DOM tree searching engine based on CSS selectors.
    SHA256 18jm89i9353khrp9q92bnqllkypcsmyd43jvdr6gl0n50fmzs5jd URL
    http://beta.quicklisp.org/archive/clss/2018-08-31/clss-20180831-git.tgz MD5
    39b69790115d6c4fe4709f5a45b5d4a4 NAME clss FILENAME clss DEPS
    ((NAME array-utils FILENAME array-utils)
     (NAME documentation-utils FILENAME documentation-utils)
     (NAME plump FILENAME plump) (NAME trivial-indent FILENAME trivial-indent))
    DEPENDENCIES (array-utils documentation-utils plump trivial-indent) VERSION
    20180831-git SIBLINGS NIL PARASITES NIL) */
