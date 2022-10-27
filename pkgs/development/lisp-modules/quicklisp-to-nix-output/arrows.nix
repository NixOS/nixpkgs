/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "arrows";
  version = "20181018-git";

  parasites = [ "arrows/test" ];

  description = "Implements -> and ->> from Clojure, as well as several expansions on the
idea.";

  deps = [ args."hu_dot_dwim_dot_stefil" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/arrows/2018-10-18/arrows-20181018-git.tgz";
    sha256 = "1b13pnn71z1dv1cwysh6p5jfgjsp3q8ivsdxfspl1hg1nh9mqa7r";
  };

  packageName = "arrows";

  asdFilesToKeep = ["arrows.asd"];
  overrides = x: x;
}
/* (SYSTEM arrows DESCRIPTION
    Implements -> and ->> from Clojure, as well as several expansions on the
idea.
    SHA256 1b13pnn71z1dv1cwysh6p5jfgjsp3q8ivsdxfspl1hg1nh9mqa7r URL
    http://beta.quicklisp.org/archive/arrows/2018-10-18/arrows-20181018-git.tgz
    MD5 c60b5d79680de19baad018a0fe87bc48 NAME arrows FILENAME arrows DEPS
    ((NAME hu.dwim.stefil FILENAME hu_dot_dwim_dot_stefil)) DEPENDENCIES
    (hu.dwim.stefil) VERSION 20181018-git SIBLINGS NIL PARASITES (arrows/test)) */
