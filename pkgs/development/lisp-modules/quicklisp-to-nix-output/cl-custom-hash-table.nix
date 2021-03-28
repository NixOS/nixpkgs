/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-custom-hash-table";
  version = "20201220-git";

  description = "System lacks description";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-custom-hash-table/2020-12-20/cl-custom-hash-table-20201220-git.tgz";
    sha256 = "1id16p7vdcgxzvrgk8h6fqi284hgd8cilbnbgsbrbd70n7nj8jg3";
  };

  packageName = "cl-custom-hash-table";

  asdFilesToKeep = ["cl-custom-hash-table.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-custom-hash-table DESCRIPTION System lacks description SHA256
    1id16p7vdcgxzvrgk8h6fqi284hgd8cilbnbgsbrbd70n7nj8jg3 URL
    http://beta.quicklisp.org/archive/cl-custom-hash-table/2020-12-20/cl-custom-hash-table-20201220-git.tgz
    MD5 bd0f2f4a8e808911133af19c03e5c511 NAME cl-custom-hash-table FILENAME
    cl-custom-hash-table DEPS NIL DEPENDENCIES NIL VERSION 20201220-git
    SIBLINGS (cl-custom-hash-table-test) PARASITES NIL) */
