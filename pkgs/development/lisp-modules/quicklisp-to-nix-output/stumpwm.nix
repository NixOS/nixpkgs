args @ { fetchurl, ... }:
{
  baseName = ''stumpwm'';
  version = ''20190710-git'';

  description = ''A tiling, keyboard driven window manager'';

  deps = [ args."alexandria" args."cl-ppcre" args."clx" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/stumpwm/2019-07-10/stumpwm-20190710-git.tgz'';
    sha256 = ''10msx6a7s28aqkdz6x847n5jhg9sykvx96p3gh2pq1ab71wq1l3w'';
  };

  packageName = "stumpwm";

  asdFilesToKeep = ["stumpwm.asd"];
  overrides = x: x;
}
/* (SYSTEM stumpwm DESCRIPTION A tiling, keyboard driven window manager SHA256
    10msx6a7s28aqkdz6x847n5jhg9sykvx96p3gh2pq1ab71wq1l3w URL
    http://beta.quicklisp.org/archive/stumpwm/2019-07-10/stumpwm-20190710-git.tgz
    MD5 7956cf3486c586f137b75f8b8c0e677c NAME stumpwm FILENAME stumpwm DEPS
    ((NAME alexandria FILENAME alexandria) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME clx FILENAME clx))
    DEPENDENCIES (alexandria cl-ppcre clx) VERSION 20190710-git SIBLINGS
    (stumpwm-tests) PARASITES NIL) */
