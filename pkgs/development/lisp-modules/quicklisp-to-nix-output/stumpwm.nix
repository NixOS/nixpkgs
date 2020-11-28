args @ { fetchurl, ... }:
rec {
  baseName = ''stumpwm'';
  version = ''20201016-git'';

  description = ''A tiling, keyboard driven window manager'';

  deps = [ args."alexandria" args."cl-ppcre" args."clx" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/stumpwm/2020-10-16/stumpwm-20201016-git.tgz'';
    sha256 = ''06lc1d9y83x0ckqd9pls7a1dyriz650mpv1rigncr02qsj3aqpp2'';
  };

  packageName = "stumpwm";

  asdFilesToKeep = ["stumpwm.asd"];
  overrides = x: x;
}
/* (SYSTEM stumpwm DESCRIPTION A tiling, keyboard driven window manager SHA256
    06lc1d9y83x0ckqd9pls7a1dyriz650mpv1rigncr02qsj3aqpp2 URL
    http://beta.quicklisp.org/archive/stumpwm/2020-10-16/stumpwm-20201016-git.tgz
    MD5 fe99208b03be907ad75b0ed388e171c3 NAME stumpwm FILENAME stumpwm DEPS
    ((NAME alexandria FILENAME alexandria) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME clx FILENAME clx))
    DEPENDENCIES (alexandria cl-ppcre clx) VERSION 20201016-git SIBLINGS
    (stumpwm-tests) PARASITES NIL) */
