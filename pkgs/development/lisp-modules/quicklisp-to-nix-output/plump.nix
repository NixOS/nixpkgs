args @ { fetchurl, ... }:
rec {
  baseName = ''plump'';
  version = ''20180228-git'';

  description = ''An XML / XHTML / HTML parser that aims to be as lenient as possible.'';

  deps = [ args."array-utils" args."documentation-utils" args."trivial-indent" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/plump/2018-02-28/plump-20180228-git.tgz'';
    sha256 = ''0q8carmnrh1qdhdag9w5iikdlga8g7jn824bjypzx0iwyqn1ap01'';
  };

  packageName = "plump";

  asdFilesToKeep = ["plump.asd"];
  overrides = x: x;
}
/* (SYSTEM plump DESCRIPTION
    An XML / XHTML / HTML parser that aims to be as lenient as possible. SHA256
    0q8carmnrh1qdhdag9w5iikdlga8g7jn824bjypzx0iwyqn1ap01 URL
    http://beta.quicklisp.org/archive/plump/2018-02-28/plump-20180228-git.tgz
    MD5 f210bc3fae00bac3140d939cbb2fd1de NAME plump FILENAME plump DEPS
    ((NAME array-utils FILENAME array-utils)
     (NAME documentation-utils FILENAME documentation-utils)
     (NAME trivial-indent FILENAME trivial-indent))
    DEPENDENCIES (array-utils documentation-utils trivial-indent) VERSION
    20180228-git SIBLINGS (plump-dom plump-lexer plump-parser) PARASITES NIL) */
