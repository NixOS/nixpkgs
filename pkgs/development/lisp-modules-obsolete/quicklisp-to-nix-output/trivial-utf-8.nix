/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "trivial-utf-8";
  version = "20211209-git";

  parasites = [ "trivial-utf-8/doc" "trivial-utf-8/tests" ];

  description = "A small library for doing UTF-8-based input and output.";

  deps = [ args."mgl-pax" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/trivial-utf-8/2021-12-09/trivial-utf-8-20211209-git.tgz";
    sha256 = "1bis8shbdva1diwms2lvhlbdz9rvazqqxi9h8d33vlbw4xai075y";
  };

  packageName = "trivial-utf-8";

  asdFilesToKeep = ["trivial-utf-8.asd"];
  overrides = x: x;
}
/* (SYSTEM trivial-utf-8 DESCRIPTION
    A small library for doing UTF-8-based input and output. SHA256
    1bis8shbdva1diwms2lvhlbdz9rvazqqxi9h8d33vlbw4xai075y URL
    http://beta.quicklisp.org/archive/trivial-utf-8/2021-12-09/trivial-utf-8-20211209-git.tgz
    MD5 65603f3c4421a93d5d8c214bb406988d NAME trivial-utf-8 FILENAME
    trivial-utf-8 DEPS ((NAME mgl-pax FILENAME mgl-pax)) DEPENDENCIES (mgl-pax)
    VERSION 20211209-git SIBLINGS NIL PARASITES
    (trivial-utf-8/doc trivial-utf-8/tests)) */
