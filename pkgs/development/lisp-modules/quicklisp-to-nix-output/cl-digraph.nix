/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-digraph";
  version = "20211020-hg";

  description = "Simple directed graphs for Common Lisp.";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-digraph/2021-10-20/cl-digraph-20211020-hg.tgz";
    sha256 = "0iqzqy322xywmal7y7vhn1myhdglr78fj89maiwfx6yjppcyd1i1";
  };

  packageName = "cl-digraph";

  asdFilesToKeep = ["cl-digraph.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-digraph DESCRIPTION Simple directed graphs for Common Lisp.
    SHA256 0iqzqy322xywmal7y7vhn1myhdglr78fj89maiwfx6yjppcyd1i1 URL
    http://beta.quicklisp.org/archive/cl-digraph/2021-10-20/cl-digraph-20211020-hg.tgz
    MD5 737c3640b4b079ce0ee730525aa8b6de NAME cl-digraph FILENAME cl-digraph
    DEPS NIL DEPENDENCIES NIL VERSION 20211020-hg SIBLINGS
    (cl-digraph.dot cl-digraph.test) PARASITES NIL) */
