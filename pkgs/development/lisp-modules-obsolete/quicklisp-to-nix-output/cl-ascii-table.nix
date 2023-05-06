/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-ascii-table";
  version = "20200610-git";

  description = "Common Lisp library to present tabular data in ascii-art table.";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-ascii-table/2020-06-10/cl-ascii-table-20200610-git.tgz";
    sha256 = "00395cbmjwlywyks3zd4mqp0w7yyms61ywp06knv1gbf847vy7yi";
  };

  packageName = "cl-ascii-table";

  asdFilesToKeep = ["cl-ascii-table.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-ascii-table DESCRIPTION
    Common Lisp library to present tabular data in ascii-art table. SHA256
    00395cbmjwlywyks3zd4mqp0w7yyms61ywp06knv1gbf847vy7yi URL
    http://beta.quicklisp.org/archive/cl-ascii-table/2020-06-10/cl-ascii-table-20200610-git.tgz
    MD5 6f2eaaae3fb03ba719d77ed3ffaeaf4f NAME cl-ascii-table FILENAME
    cl-ascii-table DEPS NIL DEPENDENCIES NIL VERSION 20200610-git SIBLINGS NIL
    PARASITES NIL) */
