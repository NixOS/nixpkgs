args @ { fetchurl, ... }:
rec {
  baseName = ''plump'';
  version = ''20180831-git'';

  description = ''An XML / XHTML / HTML parser that aims to be as lenient as possible.'';

  deps = [ args."array-utils" args."documentation-utils" args."trivial-indent" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/plump/2018-08-31/plump-20180831-git.tgz'';
    sha256 = ''0pa4z9yjm68lpw1hdidicrwj7dfvf2jk110rnqq6p8ahxc117zbf'';
  };

  packageName = "plump";

  asdFilesToKeep = ["plump.asd"];
  overrides = x: x;
}
/* (SYSTEM plump DESCRIPTION
    An XML / XHTML / HTML parser that aims to be as lenient as possible. SHA256
    0pa4z9yjm68lpw1hdidicrwj7dfvf2jk110rnqq6p8ahxc117zbf URL
    http://beta.quicklisp.org/archive/plump/2018-08-31/plump-20180831-git.tgz
    MD5 5a899a19906fd22fb0cb1c65eb584891 NAME plump FILENAME plump DEPS
    ((NAME array-utils FILENAME array-utils)
     (NAME documentation-utils FILENAME documentation-utils)
     (NAME trivial-indent FILENAME trivial-indent))
    DEPENDENCIES (array-utils documentation-utils trivial-indent) VERSION
    20180831-git SIBLINGS (plump-dom plump-lexer plump-parser) PARASITES NIL) */
