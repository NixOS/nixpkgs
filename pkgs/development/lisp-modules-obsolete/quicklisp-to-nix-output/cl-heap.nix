/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-heap";
  version = "0.1.6";

  description = "An implementation of heap and priority queue data structures.";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-heap/2013-03-12/cl-heap-0.1.6.tgz";
    sha256 = "163hb07p2nxz126rpq3cj5dyala24n0by5i5786n2qcr1w0bak4i";
  };

  packageName = "cl-heap";

  asdFilesToKeep = ["cl-heap.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-heap DESCRIPTION
    An implementation of heap and priority queue data structures. SHA256
    163hb07p2nxz126rpq3cj5dyala24n0by5i5786n2qcr1w0bak4i URL
    http://beta.quicklisp.org/archive/cl-heap/2013-03-12/cl-heap-0.1.6.tgz MD5
    a12d71f7bbe22d6acdcc7cf36fb907b0 NAME cl-heap FILENAME cl-heap DEPS NIL
    DEPENDENCIES NIL VERSION 0.1.6 SIBLINGS (cl-heap-tests) PARASITES NIL) */
