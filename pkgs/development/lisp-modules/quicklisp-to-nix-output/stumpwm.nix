args @ { fetchurl, ... }:
rec {
  baseName = ''stumpwm'';
  version = ''20180831-git'';

  description = ''A tiling, keyboard driven window manager'';

  deps = [ args."alexandria" args."cl-ppcre" args."clx" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/stumpwm/2018-08-31/stumpwm-20180831-git.tgz'';
    sha256 = ''1zis6aqdr18vd78wl9jpv2fmbzn37zvhb6gj44dpfydl67hjc89w'';
  };

  packageName = "stumpwm";

  asdFilesToKeep = ["stumpwm.asd"];
  overrides = x: x;
}
/* (SYSTEM stumpwm DESCRIPTION A tiling, keyboard driven window manager SHA256
    1zis6aqdr18vd78wl9jpv2fmbzn37zvhb6gj44dpfydl67hjc89w URL
    http://beta.quicklisp.org/archive/stumpwm/2018-08-31/stumpwm-20180831-git.tgz
    MD5 a523654c5f7ffdfe6c6c4f37e9499851 NAME stumpwm FILENAME stumpwm DEPS
    ((NAME alexandria FILENAME alexandria) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME clx FILENAME clx))
    DEPENDENCIES (alexandria cl-ppcre clx) VERSION 20180831-git SIBLINGS
    (stumpwm-tests) PARASITES NIL) */
