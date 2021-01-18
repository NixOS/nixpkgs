args @ { fetchurl, ... }:
rec {
  baseName = ''plump'';
  version = ''20200427-git'';

  description = ''An XML / XHTML / HTML parser that aims to be as lenient as possible.'';

  deps = [ args."array-utils" args."documentation-utils" args."trivial-indent" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/plump/2020-04-27/plump-20200427-git.tgz'';
    sha256 = ''0l5bi503djjkhrih94h5jbihlm60h267qm2ycq9m9fldp4fjrjic'';
  };

  packageName = "plump";

  asdFilesToKeep = ["plump.asd"];
  overrides = x: x;
}
/* (SYSTEM plump DESCRIPTION
    An XML / XHTML / HTML parser that aims to be as lenient as possible. SHA256
    0l5bi503djjkhrih94h5jbihlm60h267qm2ycq9m9fldp4fjrjic URL
    http://beta.quicklisp.org/archive/plump/2020-04-27/plump-20200427-git.tgz
    MD5 f9244ce58ee5cf5044092369e534f3b7 NAME plump FILENAME plump DEPS
    ((NAME array-utils FILENAME array-utils)
     (NAME documentation-utils FILENAME documentation-utils)
     (NAME trivial-indent FILENAME trivial-indent))
    DEPENDENCIES (array-utils documentation-utils trivial-indent) VERSION
    20200427-git SIBLINGS (plump-dom plump-lexer plump-parser) PARASITES NIL) */
