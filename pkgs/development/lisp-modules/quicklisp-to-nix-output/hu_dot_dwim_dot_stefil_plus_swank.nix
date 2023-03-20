/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "hu_dot_dwim_dot_stefil_plus_swank";
  version = "hu.dwim.stefil-20200218-darcs";

  description = "System lacks description";

  deps = [ args."alexandria" args."hu_dot_dwim_dot_asdf" args."hu_dot_dwim_dot_stefil" args."swank" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/hu.dwim.stefil/2020-02-18/hu.dwim.stefil-20200218-darcs.tgz";
    sha256 = "16p25pq9fhk0dny6r43yl9z24g6qm6dag9zf2cila9v9jh3r76qf";
  };

  packageName = "hu.dwim.stefil+swank";

  asdFilesToKeep = ["hu.dwim.stefil+swank.asd"];
  overrides = x: x;
}
/* (SYSTEM hu.dwim.stefil+swank DESCRIPTION System lacks description SHA256
    16p25pq9fhk0dny6r43yl9z24g6qm6dag9zf2cila9v9jh3r76qf URL
    http://beta.quicklisp.org/archive/hu.dwim.stefil/2020-02-18/hu.dwim.stefil-20200218-darcs.tgz
    MD5 3e87e0973f8373e342b75b13c802cc53 NAME hu.dwim.stefil+swank FILENAME
    hu_dot_dwim_dot_stefil_plus_swank DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME hu.dwim.asdf FILENAME hu_dot_dwim_dot_asdf)
     (NAME hu.dwim.stefil FILENAME hu_dot_dwim_dot_stefil)
     (NAME swank FILENAME swank))
    DEPENDENCIES (alexandria hu.dwim.asdf hu.dwim.stefil swank) VERSION
    hu.dwim.stefil-20200218-darcs SIBLINGS
    (hu.dwim.stefil+hu.dwim.def+swank hu.dwim.stefil+hu.dwim.def
     hu.dwim.stefil)
    PARASITES NIL) */
