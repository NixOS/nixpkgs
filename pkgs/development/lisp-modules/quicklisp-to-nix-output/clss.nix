args @ { fetchurl, ... }:
rec {
  baseName = ''clss'';
  version = ''20170630-git'';

  description = ''A DOM tree searching engine based on CSS selectors.'';

  deps = [ args."array-utils" args."plump" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/clss/2017-06-30/clss-20170630-git.tgz'';
    sha256 = ''0kdkzx7z997lzbf331p4fkqhri0ind7agknl9y992x917m9y4rn0'';
  };

  packageName = "clss";

  asdFilesToKeep = ["clss.asd"];
  overrides = x: x;
}
/* (SYSTEM clss DESCRIPTION A DOM tree searching engine based on CSS selectors.
    SHA256 0kdkzx7z997lzbf331p4fkqhri0ind7agknl9y992x917m9y4rn0 URL
    http://beta.quicklisp.org/archive/clss/2017-06-30/clss-20170630-git.tgz MD5
    61bbadf22391940813bfc66dfd59d304 NAME clss FILENAME clss DEPS
    ((NAME array-utils FILENAME array-utils) (NAME plump FILENAME plump))
    DEPENDENCIES (array-utils plump) VERSION 20170630-git SIBLINGS NIL
    PARASITES NIL) */
