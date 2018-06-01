args @ { fetchurl, ... }:
rec {
  baseName = ''stumpwm'';
  version = ''20180430-git'';

  description = ''A tiling, keyboard driven window manager'';

  deps = [ args."alexandria" args."cl-ppcre" args."clx" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/stumpwm/2018-04-30/stumpwm-20180430-git.tgz'';
    sha256 = ''0ayw562iya02j8rzdnzpxn5yxwaapr2jqnm83m16h4595gv1jr6m'';
  };

  packageName = "stumpwm";

  asdFilesToKeep = ["stumpwm.asd"];
  overrides = x: x;
}
/* (SYSTEM stumpwm DESCRIPTION A tiling, keyboard driven window manager SHA256
    0ayw562iya02j8rzdnzpxn5yxwaapr2jqnm83m16h4595gv1jr6m URL
    http://beta.quicklisp.org/archive/stumpwm/2018-04-30/stumpwm-20180430-git.tgz
    MD5 40e1be3872e6a87a6f9e03f8ede5e48e NAME stumpwm FILENAME stumpwm DEPS
    ((NAME alexandria FILENAME alexandria) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME clx FILENAME clx))
    DEPENDENCIES (alexandria cl-ppcre clx) VERSION 20180430-git SIBLINGS NIL
    PARASITES NIL) */
