/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "colorize";
  version = "20180228-git";

  description = "A Syntax highlighting library";

  deps = [ args."alexandria" args."html-encode" args."split-sequence" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/colorize/2018-02-28/colorize-20180228-git.tgz";
    sha256 = "1g0xbryavsf17zy9iy0sbqsb4lyva04h93sbaj3iwv12w50fwz2h";
  };

  packageName = "colorize";

  asdFilesToKeep = ["colorize.asd"];
  overrides = x: x;
}
/* (SYSTEM colorize DESCRIPTION A Syntax highlighting library SHA256
    1g0xbryavsf17zy9iy0sbqsb4lyva04h93sbaj3iwv12w50fwz2h URL
    http://beta.quicklisp.org/archive/colorize/2018-02-28/colorize-20180228-git.tgz
    MD5 1bc08c8f76b747e4d254669a205dc611 NAME colorize FILENAME colorize DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME html-encode FILENAME html-encode)
     (NAME split-sequence FILENAME split-sequence))
    DEPENDENCIES (alexandria html-encode split-sequence) VERSION 20180228-git
    SIBLINGS NIL PARASITES NIL) */
