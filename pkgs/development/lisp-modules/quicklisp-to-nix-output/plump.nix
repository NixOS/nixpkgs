args @ { fetchurl, ... }:
{
  baseName = ''plump'';
  version = ''20190710-git'';

  description = ''An XML / XHTML / HTML parser that aims to be as lenient as possible.'';

  deps = [ args."array-utils" args."documentation-utils" args."trivial-indent" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/plump/2019-07-10/plump-20190710-git.tgz'';
    sha256 = ''1in8c86a1ss8h02bsr3yb0clqgbvqh0bh5gy4y01yfckixbxh5fi'';
  };

  packageName = "plump";

  asdFilesToKeep = ["plump.asd"];
  overrides = x: x;
}
/* (SYSTEM plump DESCRIPTION
    An XML / XHTML / HTML parser that aims to be as lenient as possible. SHA256
    1in8c86a1ss8h02bsr3yb0clqgbvqh0bh5gy4y01yfckixbxh5fi URL
    http://beta.quicklisp.org/archive/plump/2019-07-10/plump-20190710-git.tgz
    MD5 e3276779e368758274156c9477f0b22a NAME plump FILENAME plump DEPS
    ((NAME array-utils FILENAME array-utils)
     (NAME documentation-utils FILENAME documentation-utils)
     (NAME trivial-indent FILENAME trivial-indent))
    DEPENDENCIES (array-utils documentation-utils trivial-indent) VERSION
    20190710-git SIBLINGS (plump-dom plump-lexer plump-parser) PARASITES NIL) */
