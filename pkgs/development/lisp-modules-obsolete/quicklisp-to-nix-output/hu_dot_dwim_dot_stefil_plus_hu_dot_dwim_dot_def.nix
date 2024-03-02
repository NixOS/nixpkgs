/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "hu_dot_dwim_dot_stefil_plus_hu_dot_dwim_dot_def";
  version = "hu.dwim.stefil-20200218-darcs";

  description = "System lacks description";

  deps = [ args."alexandria" args."anaphora" args."hu_dot_dwim_dot_asdf" args."hu_dot_dwim_dot_def" args."hu_dot_dwim_dot_stefil" args."iterate" args."metabang-bind" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/hu.dwim.stefil/2020-02-18/hu.dwim.stefil-20200218-darcs.tgz";
    sha256 = "16p25pq9fhk0dny6r43yl9z24g6qm6dag9zf2cila9v9jh3r76qf";
  };

  packageName = "hu.dwim.stefil+hu.dwim.def";

  asdFilesToKeep = ["hu.dwim.stefil+hu.dwim.def.asd"];
  overrides = x: x;
}
/* (SYSTEM hu.dwim.stefil+hu.dwim.def DESCRIPTION System lacks description
    SHA256 16p25pq9fhk0dny6r43yl9z24g6qm6dag9zf2cila9v9jh3r76qf URL
    http://beta.quicklisp.org/archive/hu.dwim.stefil/2020-02-18/hu.dwim.stefil-20200218-darcs.tgz
    MD5 3e87e0973f8373e342b75b13c802cc53 NAME hu.dwim.stefil+hu.dwim.def
    FILENAME hu_dot_dwim_dot_stefil_plus_hu_dot_dwim_dot_def DEPS
    ((NAME alexandria FILENAME alexandria) (NAME anaphora FILENAME anaphora)
     (NAME hu.dwim.asdf FILENAME hu_dot_dwim_dot_asdf)
     (NAME hu.dwim.def FILENAME hu_dot_dwim_dot_def)
     (NAME hu.dwim.stefil FILENAME hu_dot_dwim_dot_stefil)
     (NAME iterate FILENAME iterate)
     (NAME metabang-bind FILENAME metabang-bind))
    DEPENDENCIES
    (alexandria anaphora hu.dwim.asdf hu.dwim.def hu.dwim.stefil iterate
     metabang-bind)
    VERSION hu.dwim.stefil-20200218-darcs SIBLINGS
    (hu.dwim.stefil+hu.dwim.def+swank hu.dwim.stefil+swank hu.dwim.stefil)
    PARASITES NIL) */
