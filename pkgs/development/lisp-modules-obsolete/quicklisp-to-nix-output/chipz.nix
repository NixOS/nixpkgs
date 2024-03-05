/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "chipz";
  version = "20210807-git";

  description = "A library for decompressing deflate, zlib, and gzip data";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/chipz/2021-08-07/chipz-20210807-git.tgz";
    sha256 = "0g7xhh4yq9azjq7gnszaq2kbxima2q30apb3rrglc1ign973hr8x";
  };

  packageName = "chipz";

  asdFilesToKeep = ["chipz.asd"];
  overrides = x: x;
}
/* (SYSTEM chipz DESCRIPTION
    A library for decompressing deflate, zlib, and gzip data SHA256
    0g7xhh4yq9azjq7gnszaq2kbxima2q30apb3rrglc1ign973hr8x URL
    http://beta.quicklisp.org/archive/chipz/2021-08-07/chipz-20210807-git.tgz
    MD5 11438e3bc60c39294c337cb232ae8040 NAME chipz FILENAME chipz DEPS NIL
    DEPENDENCIES NIL VERSION 20210807-git SIBLINGS NIL PARASITES NIL) */
