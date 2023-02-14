/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "trivial-utf-8";
  version = "20220220-git";

  parasites = [ "trivial-utf-8/doc" "trivial-utf-8/tests" ];

  description = "A small library for doing UTF-8-based input and output.";

  deps = [ args."mgl-pax" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/trivial-utf-8/2022-02-20/trivial-utf-8-20220220-git.tgz";
    sha256 = "1q78zzpjw2m3yw3m415awy5wqkh3qx9adbgqrsf6v5q7387i8d7g";
  };

  packageName = "trivial-utf-8";

  asdFilesToKeep = ["trivial-utf-8.asd"];
  overrides = x: x;
}
/* (SYSTEM trivial-utf-8 DESCRIPTION
    A small library for doing UTF-8-based input and output. SHA256
    1q78zzpjw2m3yw3m415awy5wqkh3qx9adbgqrsf6v5q7387i8d7g URL
    http://beta.quicklisp.org/archive/trivial-utf-8/2022-02-20/trivial-utf-8-20220220-git.tgz
    MD5 7c9e40bde1c7f5579bbc71e1e3c22eb0 NAME trivial-utf-8 FILENAME
    trivial-utf-8 DEPS ((NAME mgl-pax FILENAME mgl-pax)) DEPENDENCIES (mgl-pax)
    VERSION 20220220-git SIBLINGS NIL PARASITES
    (trivial-utf-8/doc trivial-utf-8/tests)) */
