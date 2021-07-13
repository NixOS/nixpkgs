/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "plump";
  version = "20210411-git";

  description = "An XML / XHTML / HTML parser that aims to be as lenient as possible.";

  deps = [ args."array-utils" args."documentation-utils" args."trivial-indent" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/plump/2021-04-11/plump-20210411-git.tgz";
    sha256 = "05zs9blznfhapz5yiy08968hw64rzdgqgvfgc9r9da45b45pl6dp";
  };

  packageName = "plump";

  asdFilesToKeep = ["plump.asd"];
  overrides = x: x;
}
/* (SYSTEM plump DESCRIPTION
    An XML / XHTML / HTML parser that aims to be as lenient as possible. SHA256
    05zs9blznfhapz5yiy08968hw64rzdgqgvfgc9r9da45b45pl6dp URL
    http://beta.quicklisp.org/archive/plump/2021-04-11/plump-20210411-git.tgz
    MD5 055e30ed07ae793426a48b55c947f9bb NAME plump FILENAME plump DEPS
    ((NAME array-utils FILENAME array-utils)
     (NAME documentation-utils FILENAME documentation-utils)
     (NAME trivial-indent FILENAME trivial-indent))
    DEPENDENCIES (array-utils documentation-utils trivial-indent) VERSION
    20210411-git SIBLINGS (plump-dom plump-lexer plump-parser) PARASITES NIL) */
