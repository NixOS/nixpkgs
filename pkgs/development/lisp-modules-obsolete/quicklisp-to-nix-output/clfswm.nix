/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "clfswm";
  version = "20161204-git";

  description = "CLFSWM: Fullscreen Window Manager";

  deps = [ args."clx" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/clfswm/2016-12-04/clfswm-20161204-git.tgz";
    sha256 = "1jgz127721dgcv3qm1knc335gy04vzh9gl0hshp256rxi82cpp73";
  };

  packageName = "clfswm";

  asdFilesToKeep = ["clfswm.asd"];
  overrides = x: x;
}
/* (SYSTEM clfswm DESCRIPTION CLFSWM: Fullscreen Window Manager SHA256
    1jgz127721dgcv3qm1knc335gy04vzh9gl0hshp256rxi82cpp73 URL
    http://beta.quicklisp.org/archive/clfswm/2016-12-04/clfswm-20161204-git.tgz
    MD5 dc976785ef899837ab0fc50a4ed6b740 NAME clfswm FILENAME clfswm DEPS
    ((NAME clx FILENAME clx)) DEPENDENCIES (clx) VERSION 20161204-git SIBLINGS
    NIL PARASITES NIL) */
