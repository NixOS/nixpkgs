/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-store";
  version = "20200925-git";

  parasites = [ "cl-store-tests" ];

  description = "Serialization package";

  deps = [ args."rt" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-store/2020-09-25/cl-store-20200925-git.tgz";
    sha256 = "0vqlrci1634jgfg6c1dzwvx58qjjwbcbwdbpm7xxw2s823xl9jf3";
  };

  packageName = "cl-store";

  asdFilesToKeep = ["cl-store.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-store DESCRIPTION Serialization package SHA256
    0vqlrci1634jgfg6c1dzwvx58qjjwbcbwdbpm7xxw2s823xl9jf3 URL
    http://beta.quicklisp.org/archive/cl-store/2020-09-25/cl-store-20200925-git.tgz
    MD5 828a6f3035c5ef869618f6848c47efd7 NAME cl-store FILENAME cl-store DEPS
    ((NAME rt FILENAME rt)) DEPENDENCIES (rt) VERSION 20200925-git SIBLINGS NIL
    PARASITES (cl-store-tests)) */
