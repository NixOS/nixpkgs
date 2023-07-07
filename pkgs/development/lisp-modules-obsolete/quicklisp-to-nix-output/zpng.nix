/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "zpng";
  version = "1.2.2";

  description = "Create PNG files";

  deps = [ args."salza2" args."trivial-gray-streams" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/zpng/2015-04-07/zpng-1.2.2.tgz";
    sha256 = "0932gq9wncibm1z81gbvdc3ip6n118wwzmjnpxaqdy9hk5bs2w1x";
  };

  packageName = "zpng";

  asdFilesToKeep = ["zpng.asd"];
  overrides = x: x;
}
/* (SYSTEM zpng DESCRIPTION Create PNG files SHA256
    0932gq9wncibm1z81gbvdc3ip6n118wwzmjnpxaqdy9hk5bs2w1x URL
    http://beta.quicklisp.org/archive/zpng/2015-04-07/zpng-1.2.2.tgz MD5
    0a208f4ce0087ef578d477341d5f4078 NAME zpng FILENAME zpng DEPS
    ((NAME salza2 FILENAME salza2)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams))
    DEPENDENCIES (salza2 trivial-gray-streams) VERSION 1.2.2 SIBLINGS NIL
    PARASITES NIL) */
