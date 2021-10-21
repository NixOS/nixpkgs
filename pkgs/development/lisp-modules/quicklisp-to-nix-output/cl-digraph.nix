/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-digraph";
  version = "20210411-hg";

  description = "Simple directed graphs for Common Lisp.";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-digraph/2021-04-11/cl-digraph-20210411-hg.tgz";
    sha256 = "1g9l3dzw4ykvprl3id7xv4brpzz86jk70z4wfw5lkq8vpxv397fi";
  };

  packageName = "cl-digraph";

  asdFilesToKeep = ["cl-digraph.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-digraph DESCRIPTION Simple directed graphs for Common Lisp.
    SHA256 1g9l3dzw4ykvprl3id7xv4brpzz86jk70z4wfw5lkq8vpxv397fi URL
    http://beta.quicklisp.org/archive/cl-digraph/2021-04-11/cl-digraph-20210411-hg.tgz
    MD5 c7c947fb7471213b24505bff1e9287de NAME cl-digraph FILENAME cl-digraph
    DEPS NIL DEPENDENCIES NIL VERSION 20210411-hg SIBLINGS
    (cl-digraph.dot cl-digraph.test) PARASITES NIL) */
