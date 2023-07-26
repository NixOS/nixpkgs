/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "rfc2388";
  version = "20180831-git";

  description = "Implementation of RFC 2388";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/rfc2388/2018-08-31/rfc2388-20180831-git.tgz";
    sha256 = "1r7vvrlq2wl213bm2aknkf34ynpl8y4nbkfir79srrdsl1337z33";
  };

  packageName = "rfc2388";

  asdFilesToKeep = ["rfc2388.asd"];
  overrides = x: x;
}
/* (SYSTEM rfc2388 DESCRIPTION Implementation of RFC 2388 SHA256
    1r7vvrlq2wl213bm2aknkf34ynpl8y4nbkfir79srrdsl1337z33 URL
    http://beta.quicklisp.org/archive/rfc2388/2018-08-31/rfc2388-20180831-git.tgz
    MD5 f57e3c588e5e08210516260e67d69226 NAME rfc2388 FILENAME rfc2388 DEPS NIL
    DEPENDENCIES NIL VERSION 20180831-git SIBLINGS NIL PARASITES NIL) */
