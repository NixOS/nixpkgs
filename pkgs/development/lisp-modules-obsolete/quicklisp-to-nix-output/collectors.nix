/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "collectors";
  version = "20161204-git";

  parasites = [ "collectors-test" ];

  description = "A library providing various collector type macros
   pulled from arnesi into its own library and stripped of dependencies";

  deps = [ args."alexandria" args."closer-mop" args."iterate" args."lisp-unit2" args."symbol-munger" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/collectors/2016-12-04/collectors-20161204-git.tgz";
    sha256 = "0cf2y2yxraqs9v54gbj8hhp7s522gz8qfwwc5hvlhl2s7540b2zf";
  };

  packageName = "collectors";

  asdFilesToKeep = ["collectors.asd"];
  overrides = x: x;
}
/* (SYSTEM collectors DESCRIPTION
    A library providing various collector type macros
   pulled from arnesi into its own library and stripped of dependencies
    SHA256 0cf2y2yxraqs9v54gbj8hhp7s522gz8qfwwc5hvlhl2s7540b2zf URL
    http://beta.quicklisp.org/archive/collectors/2016-12-04/collectors-20161204-git.tgz
    MD5 59c8c885a8e512d4f09e73d3e0c97b1f NAME collectors FILENAME collectors
    DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME closer-mop FILENAME closer-mop) (NAME iterate FILENAME iterate)
     (NAME lisp-unit2 FILENAME lisp-unit2)
     (NAME symbol-munger FILENAME symbol-munger))
    DEPENDENCIES (alexandria closer-mop iterate lisp-unit2 symbol-munger)
    VERSION 20161204-git SIBLINGS NIL PARASITES (collectors-test)) */
