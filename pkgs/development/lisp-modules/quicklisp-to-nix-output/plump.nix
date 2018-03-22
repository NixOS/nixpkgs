args @ { fetchurl, ... }:
rec {
  baseName = ''plump'';
  version = ''20180131-git'';

  description = ''An XML / XHTML / HTML parser that aims to be as lenient as possible.'';

  deps = [ args."array-utils" args."documentation-utils" args."trivial-indent" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/plump/2018-01-31/plump-20180131-git.tgz'';
    sha256 = ''12kawjp88kh7cl2f3s2rg3fp3m09pr477nl9nxcfhmfkbrprslis'';
  };

  packageName = "plump";

  asdFilesToKeep = ["plump.asd"];
  overrides = x: x;
}
/* (SYSTEM plump DESCRIPTION
    An XML / XHTML / HTML parser that aims to be as lenient as possible. SHA256
    12kawjp88kh7cl2f3s2rg3fp3m09pr477nl9nxcfhmfkbrprslis URL
    http://beta.quicklisp.org/archive/plump/2018-01-31/plump-20180131-git.tgz
    MD5 b9e7e174b2322b6547bca7beddda6f3b NAME plump FILENAME plump DEPS
    ((NAME array-utils FILENAME array-utils)
     (NAME documentation-utils FILENAME documentation-utils)
     (NAME trivial-indent FILENAME trivial-indent))
    DEPENDENCIES (array-utils documentation-utils trivial-indent) VERSION
    20180131-git SIBLINGS (plump-dom plump-lexer plump-parser) PARASITES NIL) */
