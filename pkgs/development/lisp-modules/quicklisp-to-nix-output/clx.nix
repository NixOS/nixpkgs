/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "clx";
  version = "20210630-git";

  parasites = [ "clx/test" ];

  description = "An implementation of the X Window System protocol in Lisp.";

  deps = [ args."fiasco" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/clx/2021-06-30/clx-20210630-git.tgz";
    sha256 = "0pr4majs7d6d14p52zapn5knvf7hhwm6s8abkn3xbfxgzi9np556";
  };

  packageName = "clx";

  asdFilesToKeep = ["clx.asd"];
  overrides = x: x;
}
/* (SYSTEM clx DESCRIPTION
    An implementation of the X Window System protocol in Lisp. SHA256
    0pr4majs7d6d14p52zapn5knvf7hhwm6s8abkn3xbfxgzi9np556 URL
    http://beta.quicklisp.org/archive/clx/2021-06-30/clx-20210630-git.tgz MD5
    095657b0f48ff5602525faa2d4ff7a3e NAME clx FILENAME clx DEPS
    ((NAME fiasco FILENAME fiasco)) DEPENDENCIES (fiasco) VERSION 20210630-git
    SIBLINGS NIL PARASITES (clx/test)) */
