/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "yason";
  version = "20220220-git";

  description = "JSON parser/encoder";

  deps = [ args."alexandria" args."trivial-gray-streams" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/yason/2022-02-20/yason-20220220-git.tgz";
    sha256 = "01axmpai6pvv26qpjpgqvrfq25shrzw35w7nkz4y4b9d2yknyjdi";
  };

  packageName = "yason";

  asdFilesToKeep = ["yason.asd"];
  overrides = x: x;
}
/* (SYSTEM yason DESCRIPTION JSON parser/encoder SHA256
    01axmpai6pvv26qpjpgqvrfq25shrzw35w7nkz4y4b9d2yknyjdi URL
    http://beta.quicklisp.org/archive/yason/2022-02-20/yason-20220220-git.tgz
    MD5 0e940b30c70c5748a72ee40b16aa4a5e NAME yason FILENAME yason DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams))
    DEPENDENCIES (alexandria trivial-gray-streams) VERSION 20220220-git
    SIBLINGS NIL PARASITES NIL) */
