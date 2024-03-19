/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "stumpwm";
  version = "20211209-git";

  description = "A tiling, keyboard driven window manager";

  deps = [ args."alexandria" args."cl-ppcre" args."clx" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/stumpwm/2021-12-09/stumpwm-20211209-git.tgz";
    sha256 = "1n7wj2jn6sydnyrjmic53lqkqigk1cg140b9pcnk09ngsrq3cn60";
  };

  packageName = "stumpwm";

  asdFilesToKeep = ["stumpwm.asd"];
  overrides = x: x;
}
/* (SYSTEM stumpwm DESCRIPTION A tiling, keyboard driven window manager SHA256
    1n7wj2jn6sydnyrjmic53lqkqigk1cg140b9pcnk09ngsrq3cn60 URL
    http://beta.quicklisp.org/archive/stumpwm/2021-12-09/stumpwm-20211209-git.tgz
    MD5 a556b95108398e56159bafe31c4dbabf NAME stumpwm FILENAME stumpwm DEPS
    ((NAME alexandria FILENAME alexandria) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME clx FILENAME clx))
    DEPENDENCIES (alexandria cl-ppcre clx) VERSION 20211209-git SIBLINGS
    (stumpwm-tests) PARASITES NIL) */
