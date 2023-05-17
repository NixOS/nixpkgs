/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "heap";
  version = "20181018-git";

  description = "Binary Heap for Common Lisp.";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/heap/2018-10-18/heap-20181018-git.tgz";
    sha256 = "1376i9vq5kcskzhqfxvsfvxz7kwkp6d3bd7rxn94dgnha988fd77";
  };

  packageName = "heap";

  asdFilesToKeep = ["heap.asd"];
  overrides = x: x;
}
/* (SYSTEM heap DESCRIPTION Binary Heap for Common Lisp. SHA256
    1376i9vq5kcskzhqfxvsfvxz7kwkp6d3bd7rxn94dgnha988fd77 URL
    http://beta.quicklisp.org/archive/heap/2018-10-18/heap-20181018-git.tgz MD5
    a2355ef9c113a3335919a45195083951 NAME heap FILENAME heap DEPS NIL
    DEPENDENCIES NIL VERSION 20181018-git SIBLINGS NIL PARASITES NIL) */
