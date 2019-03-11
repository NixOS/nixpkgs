args @ { fetchurl, ... }:
rec {
  baseName = ''plump'';
  version = ''20190107-git'';

  description = ''An XML / XHTML / HTML parser that aims to be as lenient as possible.'';

  deps = [ args."array-utils" args."documentation-utils" args."trivial-indent" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/plump/2019-01-07/plump-20190107-git.tgz'';
    sha256 = ''0kc93374dvr9mz6k4c0xx47jjx5sjrxs151vnnpx8jxr4cc620l3'';
  };

  packageName = "plump";

  asdFilesToKeep = ["plump.asd"];
  overrides = x: x;
}
/* (SYSTEM plump DESCRIPTION
    An XML / XHTML / HTML parser that aims to be as lenient as possible. SHA256
    0kc93374dvr9mz6k4c0xx47jjx5sjrxs151vnnpx8jxr4cc620l3 URL
    http://beta.quicklisp.org/archive/plump/2019-01-07/plump-20190107-git.tgz
    MD5 5b1a46b83536d5bf1a082a1ef191d3aa NAME plump FILENAME plump DEPS
    ((NAME array-utils FILENAME array-utils)
     (NAME documentation-utils FILENAME documentation-utils)
     (NAME trivial-indent FILENAME trivial-indent))
    DEPENDENCIES (array-utils documentation-utils trivial-indent) VERSION
    20190107-git SIBLINGS (plump-dom plump-lexer plump-parser) PARASITES NIL) */
