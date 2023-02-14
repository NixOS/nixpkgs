/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "hu_dot_dwim_dot_defclass-star";
  version = "stable-git";

  parasites = [ "hu.dwim.defclass-star/test" ];

  description = "Simplify class like definitions with defclass* and friends.";

  deps = [ args."hu_dot_dwim_dot_asdf" args."hu_dot_dwim_dot_common" args."hu_dot_dwim_dot_stefil_plus_hu_dot_dwim_dot_def_plus_swank" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/hu.dwim.defclass-star/2021-12-30/hu.dwim.defclass-star-stable-git.tgz";
    sha256 = "13isdvccyf383p0s5s63a3dh7j7jr7dvl2ywbaprv6c1gpx7fbdj";
  };

  packageName = "hu.dwim.defclass-star";

  asdFilesToKeep = ["hu.dwim.defclass-star.asd"];
  overrides = x: x;
}
/* (SYSTEM hu.dwim.defclass-star DESCRIPTION
    Simplify class like definitions with defclass* and friends. SHA256
    13isdvccyf383p0s5s63a3dh7j7jr7dvl2ywbaprv6c1gpx7fbdj URL
    http://beta.quicklisp.org/archive/hu.dwim.defclass-star/2021-12-30/hu.dwim.defclass-star-stable-git.tgz
    MD5 4ea430dc53b6fdca3de78bb18ec04d31 NAME hu.dwim.defclass-star FILENAME
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
