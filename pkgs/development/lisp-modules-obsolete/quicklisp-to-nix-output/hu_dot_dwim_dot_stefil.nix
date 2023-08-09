/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "hu_dot_dwim_dot_stefil";
  version = "20200218-darcs";

  parasites = [ "hu.dwim.stefil/test" ];

  description = "A Simple Test Framework In Lisp.";

  deps = [ args."alexandria" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/hu.dwim.stefil/2020-02-18/hu.dwim.stefil-20200218-darcs.tgz";
    sha256 = "16p25pq9fhk0dny6r43yl9z24g6qm6dag9zf2cila9v9jh3r76qf";
  };

  packageName = "hu.dwim.stefil";

  asdFilesToKeep = ["hu.dwim.stefil.asd"];
  overrides = x: x;
}
/* (SYSTEM hu.dwim.stefil DESCRIPTION A Simple Test Framework In Lisp. SHA256
    16p25pq9fhk0dny6r43yl9z24g6qm6dag9zf2cila9v9jh3r76qf URL
    http://beta.quicklisp.org/archive/hu.dwim.stefil/2020-02-18/hu.dwim.stefil-20200218-darcs.tgz
    MD5 3e87e0973f8373e342b75b13c802cc53 NAME hu.dwim.stefil FILENAME
    hu_dot_dwim_dot_stefil DEPS ((NAME alexandria FILENAME alexandria))
    DEPENDENCIES (alexandria) VERSION 20200218-darcs SIBLINGS
    (hu.dwim.stefil+hu.dwim.def+swank hu.dwim.stefil+hu.dwim.def
     hu.dwim.stefil+swank)
    PARASITES (hu.dwim.stefil/test)) */
