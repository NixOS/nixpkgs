/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "stumpwm";
  version = "20210807-git";

  description = "A tiling, keyboard driven window manager";

  deps = [ args."alexandria" args."cl-ppcre" args."clx" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/stumpwm/2021-08-07/stumpwm-20210807-git.tgz";
    sha256 = "0j9wb6djsyf2r2a4paj2s1f2sbw70wnr999abrsrkljxpayyma82";
  };

  packageName = "stumpwm";

  asdFilesToKeep = ["stumpwm.asd"];
  overrides = x: x;
}
/* (SYSTEM stumpwm DESCRIPTION A tiling, keyboard driven window manager SHA256
    0j9wb6djsyf2r2a4paj2s1f2sbw70wnr999abrsrkljxpayyma82 URL
    http://beta.quicklisp.org/archive/stumpwm/2021-08-07/stumpwm-20210807-git.tgz
    MD5 ec6d05208e0899fc929d2ea4ba61de9d NAME stumpwm FILENAME stumpwm DEPS
    ((NAME alexandria FILENAME alexandria) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME clx FILENAME clx))
    DEPENDENCIES (alexandria cl-ppcre clx) VERSION 20210807-git SIBLINGS
    (stumpwm-tests) PARASITES NIL) */
