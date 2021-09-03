/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-speedy-queue";
  version = "20150302-git";

  description = "cl-speedy-queue is a portable, non-consing, optimized queue implementation.";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-speedy-queue/2015-03-02/cl-speedy-queue-20150302-git.tgz";
    sha256 = "1w83vckk0ldr61vpkwg4i8l2b2yx54cs4ak62j4lxhshax105rqr";
  };

  packageName = "cl-speedy-queue";

  asdFilesToKeep = ["cl-speedy-queue.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-speedy-queue DESCRIPTION
    cl-speedy-queue is a portable, non-consing, optimized queue implementation.
    SHA256 1w83vckk0ldr61vpkwg4i8l2b2yx54cs4ak62j4lxhshax105rqr URL
    http://beta.quicklisp.org/archive/cl-speedy-queue/2015-03-02/cl-speedy-queue-20150302-git.tgz
    MD5 509d1acf7e4cfcef99127de75b16521f NAME cl-speedy-queue FILENAME
    cl-speedy-queue DEPS NIL DEPENDENCIES NIL VERSION 20150302-git SIBLINGS NIL
    PARASITES NIL) */
