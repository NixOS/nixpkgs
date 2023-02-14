/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "hu_dot_dwim_dot_defclass-star_plus_hu_dot_dwim_dot_def";
  version = "hu.dwim.defclass-star-stable-git";

  description = "System lacks description";

  deps = [ args."alexandria" args."anaphora" args."hu_dot_dwim_dot_asdf" args."hu_dot_dwim_dot_def" args."hu_dot_dwim_dot_defclass-star" args."iterate" args."metabang-bind" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/hu.dwim.defclass-star/2021-12-30/hu.dwim.defclass-star-stable-git.tgz";
    sha256 = "13isdvccyf383p0s5s63a3dh7j7jr7dvl2ywbaprv6c1gpx7fbdj";
  };

  packageName = "hu.dwim.defclass-star+hu.dwim.def";

  asdFilesToKeep = ["hu.dwim.defclass-star+hu.dwim.def.asd"];
  overrides = x: x;
}
/* (SYSTEM hu.dwim.defclass-star+hu.dwim.def DESCRIPTION
    System lacks description SHA256
    13isdvccyf383p0s5s63a3dh7j7jr7dvl2ywbaprv6c1gpx7fbdj URL
    http://beta.quicklisp.org/archive/hu.dwim.defclass-star/2021-12-30/hu.dwim.defclass-star-stable-git.tgz
    MD5 4ea430dc53b6fdca3de78bb18ec04d31 NAME hu.dwim.defclass-star+hu.dwim.def
    FILENAME hu_dot_dwim_dot_defclass-star_plus_hu_dot_dwim_dot_def DEPS
    ((NAME alexandria FILENAME alexandria) (NAME anaphora FILENAME anaphora)
     (NAME hu.dwim.asdf FILENAME hu_dot_dwim_dot_asdf)
     (NAME hu.dwim.def FILENAME hu_dot_dwim_dot_def)
     (NAME hu.dwim.defclass-star FILENAME hu_dot_dwim_dot_defclass-star)
     (NAME iterate FILENAME iterate)
     (NAME metabang-bind FILENAME metabang-bind))
    DEPENDENCIES
    (alexandria anaphora hu.dwim.asdf hu.dwim.def hu.dwim.defclass-star iterate
     metabang-bind)
    VERSION hu.dwim.defclass-star-stable-git SIBLINGS
    (hu.dwim.defclass-star+contextl hu.dwim.defclass-star+hu.dwim.def+contextl
     hu.dwim.defclass-star+swank hu.dwim.defclass-star)
    PARASITES NIL) */
