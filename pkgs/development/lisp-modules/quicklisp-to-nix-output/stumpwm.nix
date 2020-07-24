args @ { fetchurl, ... }:
rec {
  baseName = ''stumpwm'';
  version = ''20191227-git'';

  description = ''A tiling, keyboard driven window manager'';

  deps = [ args."alexandria" args."cl-ppcre" args."clx" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/stumpwm/2019-12-27/stumpwm-20191227-git.tgz'';
    sha256 = ''1dlw4y1mpsmgx7r0mdiccvnv56xpbq0rigyb2n04kq4hkp7zj6rm'';
  };

  packageName = "stumpwm";

  asdFilesToKeep = ["stumpwm.asd"];
  overrides = x: x;
}
/* (SYSTEM stumpwm DESCRIPTION A tiling, keyboard driven window manager SHA256
    1dlw4y1mpsmgx7r0mdiccvnv56xpbq0rigyb2n04kq4hkp7zj6rm URL
    http://beta.quicklisp.org/archive/stumpwm/2019-12-27/stumpwm-20191227-git.tgz
    MD5 247f56ddbdc8bdf4cf087a467ddce6f6 NAME stumpwm FILENAME stumpwm DEPS
    ((NAME alexandria FILENAME alexandria) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME clx FILENAME clx))
    DEPENDENCIES (alexandria cl-ppcre clx) VERSION 20191227-git SIBLINGS
    (stumpwm-tests) PARASITES NIL) */
