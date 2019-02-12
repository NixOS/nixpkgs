args @ { fetchurl, ... }:
rec {
  baseName = ''stumpwm'';
  version = ''20190107-git'';

  description = ''A tiling, keyboard driven window manager'';

  deps = [ args."alexandria" args."cl-ppcre" args."clx" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/stumpwm/2019-01-07/stumpwm-20190107-git.tgz'';
    sha256 = ''1i9l1jaxa38fp6s3wmbg5cnn27j4ry8z1mh3w5bhyq0b54zxbcar'';
  };

  packageName = "stumpwm";

  asdFilesToKeep = ["stumpwm.asd"];
  overrides = x: x;
}
/* (SYSTEM stumpwm DESCRIPTION A tiling, keyboard driven window manager SHA256
    1i9l1jaxa38fp6s3wmbg5cnn27j4ry8z1mh3w5bhyq0b54zxbcar URL
    http://beta.quicklisp.org/archive/stumpwm/2019-01-07/stumpwm-20190107-git.tgz
    MD5 5634a308f5b40d9bab1f7c066aa6b9df NAME stumpwm FILENAME stumpwm DEPS
    ((NAME alexandria FILENAME alexandria) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME clx FILENAME clx))
    DEPENDENCIES (alexandria cl-ppcre clx) VERSION 20190107-git SIBLINGS
    (stumpwm-tests) PARASITES NIL) */
