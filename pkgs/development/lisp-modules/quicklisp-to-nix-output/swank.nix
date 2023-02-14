/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "swank";
  version = "slime-v2.27";

  description = "System lacks description";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/slime/2022-02-20/slime-v2.27.tgz";
    sha256 = "1aqnsqqb9jazymzc5lb9sq12ky3bq0q4frsndpi9nqa3k3hda4cf";
  };

  packageName = "swank";

  asdFilesToKeep = ["swank.asd"];
  overrides = x: x;
}
/* (SYSTEM swank DESCRIPTION System lacks description SHA256
    1aqnsqqb9jazymzc5lb9sq12ky3bq0q4frsndpi9nqa3k3hda4cf URL
    http://beta.quicklisp.org/archive/slime/2022-02-20/slime-v2.27.tgz MD5
    fa228382eae3cb59451d41d54264f115 NAME swank FILENAME swank DEPS NIL
    DEPENDENCIES NIL VERSION slime-v2.27 SIBLINGS NIL PARASITES NIL) */
