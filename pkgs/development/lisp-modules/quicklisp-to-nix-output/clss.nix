args @ { fetchurl, ... }:
rec {
  baseName = ''clss'';
  version = ''20180131-git'';

  description = ''A DOM tree searching engine based on CSS selectors.'';

  deps = [ args."array-utils" args."documentation-utils" args."plump" args."trivial-indent" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/clss/2018-01-31/clss-20180131-git.tgz'';
    sha256 = ''0d4sblafhm5syjkv89h45i98dykpznb0ga3q9a2cxlvl98yklg8r'';
  };

  packageName = "clss";

  asdFilesToKeep = ["clss.asd"];
  overrides = x: x;
}
/* (SYSTEM clss DESCRIPTION A DOM tree searching engine based on CSS selectors.
    SHA256 0d4sblafhm5syjkv89h45i98dykpznb0ga3q9a2cxlvl98yklg8r URL
    http://beta.quicklisp.org/archive/clss/2018-01-31/clss-20180131-git.tgz MD5
    138244b7871d8ea832832aa9cc5867e6 NAME clss FILENAME clss DEPS
    ((NAME array-utils FILENAME array-utils)
     (NAME documentation-utils FILENAME documentation-utils)
     (NAME plump FILENAME plump) (NAME trivial-indent FILENAME trivial-indent))
    DEPENDENCIES (array-utils documentation-utils plump trivial-indent) VERSION
    20180131-git SIBLINGS NIL PARASITES NIL) */
