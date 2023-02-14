/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "stumpwm";
  version = "20220220-git";

  parasites = [ "stumpwm/build" ];

  description = "A tiling, keyboard driven window manager";

  deps = [ args."alexandria" args."cl-ppcre" args."clx" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/stumpwm/2022-02-20/stumpwm-20220220-git.tgz";
    sha256 = "0h4pi5p4hw0qcgr9vcgj3narwc8dmlxdm1fi67dj17a3bxcbyrid";
  };

  packageName = "stumpwm";

  asdFilesToKeep = ["stumpwm.asd"];
  overrides = x: x;
}
/* (SYSTEM stumpwm DESCRIPTION A tiling, keyboard driven window manager SHA256
    0h4pi5p4hw0qcgr9vcgj3narwc8dmlxdm1fi67dj17a3bxcbyrid URL
    http://beta.quicklisp.org/archive/stumpwm/2022-02-20/stumpwm-20220220-git.tgz
    MD5 d877a2526c927db3804ede91ec05ce36 NAME stumpwm FILENAME stumpwm DEPS
    ((NAME alexandria FILENAME alexandria) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME clx FILENAME clx))
    DEPENDENCIES (alexandria cl-ppcre clx) VERSION 20220220-git SIBLINGS
    (stumpwm-tests) PARASITES (stumpwm/build)) */
