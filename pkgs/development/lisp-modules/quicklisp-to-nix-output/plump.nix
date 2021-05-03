/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "plump";
  version = "20210124-git";

  description = "An XML / XHTML / HTML parser that aims to be as lenient as possible.";

  deps = [ args."array-utils" args."documentation-utils" args."trivial-indent" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/plump/2021-01-24/plump-20210124-git.tgz";
    sha256 = "0br64xiz4mgmmsvkfmi43k2q16rmc6hbqf976x8cdafs3h266jdm";
  };

  packageName = "plump";

  asdFilesToKeep = ["plump.asd"];
  overrides = x: x;
}
/* (SYSTEM plump DESCRIPTION
    An XML / XHTML / HTML parser that aims to be as lenient as possible. SHA256
    0br64xiz4mgmmsvkfmi43k2q16rmc6hbqf976x8cdafs3h266jdm URL
    http://beta.quicklisp.org/archive/plump/2021-01-24/plump-20210124-git.tgz
    MD5 44a5d371dd1c3d4afc6b8801926b059a NAME plump FILENAME plump DEPS
    ((NAME array-utils FILENAME array-utils)
     (NAME documentation-utils FILENAME documentation-utils)
     (NAME trivial-indent FILENAME trivial-indent))
    DEPENDENCIES (array-utils documentation-utils trivial-indent) VERSION
    20210124-git SIBLINGS (plump-dom plump-lexer plump-parser) PARASITES NIL) */
