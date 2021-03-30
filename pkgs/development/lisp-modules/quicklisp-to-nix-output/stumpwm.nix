/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "stumpwm";
  version = "20210228-git";

  description = "A tiling, keyboard driven window manager";

  deps = [ args."alexandria" args."cl-ppcre" args."clx" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/stumpwm/2021-02-28/stumpwm-20210228-git.tgz";
    sha256 = "0vfhn90vfyhlbjkfkzx0i7i6qh79p9q4c4hhsym80niz508xw5v8";
  };

  packageName = "stumpwm";

  asdFilesToKeep = ["stumpwm.asd"];
  overrides = x: x;
}
/* (SYSTEM stumpwm DESCRIPTION A tiling, keyboard driven window manager SHA256
    0vfhn90vfyhlbjkfkzx0i7i6qh79p9q4c4hhsym80niz508xw5v8 URL
    http://beta.quicklisp.org/archive/stumpwm/2021-02-28/stumpwm-20210228-git.tgz
    MD5 0506bcd0951463ea45cebfdb5ce76511 NAME stumpwm FILENAME stumpwm DEPS
    ((NAME alexandria FILENAME alexandria) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME clx FILENAME clx))
    DEPENDENCIES (alexandria cl-ppcre clx) VERSION 20210228-git SIBLINGS
    (stumpwm-tests) PARASITES NIL) */
