/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "uuid";
  version = "20200715-git";

  description = "UUID Generation";

  deps = [ args."alexandria" args."bordeaux-threads" args."ironclad" args."trivial-utf-8" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/uuid/2020-07-15/uuid-20200715-git.tgz";
    sha256 = "1ymir6hgax1vbbcgyprnwbsx224ih03a55v10l35xridwyzhzrx0";
  };

  packageName = "uuid";

  asdFilesToKeep = ["uuid.asd"];
  overrides = x: x;
}
/* (SYSTEM uuid DESCRIPTION UUID Generation SHA256
    1ymir6hgax1vbbcgyprnwbsx224ih03a55v10l35xridwyzhzrx0 URL
    http://beta.quicklisp.org/archive/uuid/2020-07-15/uuid-20200715-git.tgz MD5
    e550de5e4e0f8cc9dc92aff0b488a991 NAME uuid FILENAME uuid DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME ironclad FILENAME ironclad)
     (NAME trivial-utf-8 FILENAME trivial-utf-8))
    DEPENDENCIES (alexandria bordeaux-threads ironclad trivial-utf-8) VERSION
    20200715-git SIBLINGS NIL PARASITES NIL) */
