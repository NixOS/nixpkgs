/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "yason";
  version = "v0.7.8";

  description = "JSON parser/encoder";

  deps = [ args."alexandria" args."trivial-gray-streams" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/yason/2019-12-27/yason-v0.7.8.tgz";
    sha256 = "11d51i2iw4nxsparwbh3s6w9zyms3wi0z0fprwz1d3sqlf03j6f1";
  };

  packageName = "yason";

  asdFilesToKeep = ["yason.asd"];
  overrides = x: x;
}
/* (SYSTEM yason DESCRIPTION JSON parser/encoder SHA256
    11d51i2iw4nxsparwbh3s6w9zyms3wi0z0fprwz1d3sqlf03j6f1 URL
    http://beta.quicklisp.org/archive/yason/2019-12-27/yason-v0.7.8.tgz MD5
    7c3231635aa494f1721273713ea8c56a NAME yason FILENAME yason DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams))
    DEPENDENCIES (alexandria trivial-gray-streams) VERSION v0.7.8 SIBLINGS NIL
    PARASITES NIL) */
