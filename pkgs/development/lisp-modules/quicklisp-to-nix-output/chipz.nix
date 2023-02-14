/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "chipz";
  version = "20220220-git";

  description = "A library for decompressing deflate, zlib, and gzip data";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/chipz/2022-02-20/chipz-20220220-git.tgz";
    sha256 = "1j3hraigg0qnxdl7ib2licpzg62sr4a6v6iszwindmxm9icrdn1s";
  };

  packageName = "chipz";

  asdFilesToKeep = ["chipz.asd"];
  overrides = x: x;
}
/* (SYSTEM chipz DESCRIPTION
    A library for decompressing deflate, zlib, and gzip data SHA256
    1j3hraigg0qnxdl7ib2licpzg62sr4a6v6iszwindmxm9icrdn1s URL
    http://beta.quicklisp.org/archive/chipz/2022-02-20/chipz-20220220-git.tgz
    MD5 b14d05a5a12c3e5cf4bf50e98c679fd7 NAME chipz FILENAME chipz DEPS NIL
    DEPENDENCIES NIL VERSION 20220220-git SIBLINGS NIL PARASITES NIL) */
