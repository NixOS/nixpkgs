/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "hu_dot_dwim_dot_defclass-star";
  version = "stable-git";

  parasites = [ "hu.dwim.defclass-star/test" ];

  description = "Simplify class like definitions with defclass* and friends.";

  deps = [ args."hu_dot_dwim_dot_asdf" args."hu_dot_dwim_dot_common" args."hu_dot_dwim_dot_stefil_plus_hu_dot_dwim_dot_def_plus_swank" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/hu.dwim.defclass-star/2021-12-09/hu.dwim.defclass-star-stable-git.tgz";
    sha256 = "0draahmhi5mmrj9aqabqdaipqcb9adxqdypjbdiawg55dw36g0cy";
  };

  packageName = "hu.dwim.defclass-star";

  asdFilesToKeep = ["hu.dwim.defclass-star.asd"];
  overrides = x: x;
}
/* (SYSTEM hu.dwim.defclass-star DESCRIPTION
    Simplify class like definitions with defclass* and friends. SHA256
    0draahmhi5mmrj9aqabqdaipqcb9adxqdypjbdiawg55dw36g0cy URL
    http://beta.quicklisp.org/archive/hu.dwim.defclass-star/2021-12-09/hu.dwim.defclass-star-stable-git.tgz
    MD5 e35fa9767089eb2fb03befaec18d5081 NAME hu.dwim.defclass-star FILENAME
    hu_dot_dwim_dot_defclass-star DEPS
    ((NAME hu.dwim.asdf FILENAME hu_dot_dwim_dot_asdf)
     (NAME hu.dwim.common FILENAME hu_dot_dwim_dot_common)
     (NAME hu.dwim.stefil+hu.dwim.def+swank FILENAME
      hu_dot_dwim_dot_stefil_plus_hu_dot_dwim_dot_def_plus_swank))
    DEPENDENCIES (hu.dwim.asdf hu.dwim.common hu.dwim.stefil+hu.dwim.def+swank)
    VERSION stable-git SIBLINGS
    (hu.dwim.defclass-star+contextl hu.dwim.defclass-star+hu.dwim.def+contextl
     hu.dwim.defclass-star+hu.dwim.def hu.dwim.defclass-star+swank)
    PARASITES (hu.dwim.defclass-star/test)) */
