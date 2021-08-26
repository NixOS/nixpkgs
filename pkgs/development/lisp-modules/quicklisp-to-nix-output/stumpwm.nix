/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "stumpwm";
  version = "20210411-git";

  description = "A tiling, keyboard driven window manager";

  deps = [ args."alexandria" args."cl-ppcre" args."clx" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/stumpwm/2021-04-11/stumpwm-20210411-git.tgz";
    sha256 = "0rrhmryfgbjrl04ww107pvm4lzm620xp7a5kwhqbh5d7hpbdk49j";
  };

  packageName = "stumpwm";

  asdFilesToKeep = ["stumpwm.asd"];
  overrides = x: x;
}
/* (SYSTEM stumpwm DESCRIPTION A tiling, keyboard driven window manager SHA256
    0rrhmryfgbjrl04ww107pvm4lzm620xp7a5kwhqbh5d7hpbdk49j URL
    http://beta.quicklisp.org/archive/stumpwm/2021-04-11/stumpwm-20210411-git.tgz
    MD5 4497670e2aac3038ed5fb87121ff1b7a NAME stumpwm FILENAME stumpwm DEPS
    ((NAME alexandria FILENAME alexandria) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME clx FILENAME clx))
    DEPENDENCIES (alexandria cl-ppcre clx) VERSION 20210411-git SIBLINGS
    (stumpwm-tests) PARASITES NIL) */
