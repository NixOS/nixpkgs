args @ { fetchurl, ... }:
rec {
  baseName = ''stumpwm'';
  version = ''20180131-git'';

  description = ''A tiling, keyboard driven window manager'';

  deps = [ args."alexandria" args."cl-ppcre" args."clx" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/stumpwm/2018-01-31/stumpwm-20180131-git.tgz'';
    sha256 = ''1mlwgs0b8hd64wqk9qcv2x08zzfvbnn81fsdza7v5rcb8mx5abg0'';
  };

  packageName = "stumpwm";

  asdFilesToKeep = ["stumpwm.asd"];
  overrides = x: x;
}
/* (SYSTEM stumpwm DESCRIPTION A tiling, keyboard driven window manager SHA256
    1mlwgs0b8hd64wqk9qcv2x08zzfvbnn81fsdza7v5rcb8mx5abg0 URL
    http://beta.quicklisp.org/archive/stumpwm/2018-01-31/stumpwm-20180131-git.tgz
    MD5 252427acf3f2dbc2a5522598c4e37be1 NAME stumpwm FILENAME stumpwm DEPS
    ((NAME alexandria FILENAME alexandria) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME clx FILENAME clx))
    DEPENDENCIES (alexandria cl-ppcre clx) VERSION 20180131-git SIBLINGS NIL
    PARASITES NIL) */
