args @ { fetchurl, ... }:
rec {
  baseName = ''hu_dot_dwim_dot_defclass-star'';
  version = ''20150709-darcs'';

  description = ''Simplify class like definitions with defclass* and friends.'';

  deps = [ args."hu_dot_dwim_dot_asdf" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/hu.dwim.defclass-star/2015-07-09/hu.dwim.defclass-star-20150709-darcs.tgz'';
    sha256 = ''032982lyp0hm0ssxlyh572whi2hr4j1nqkyqlllaj373v0dbs3vs'';
  };

  packageName = "hu.dwim.defclass-star";

  asdFilesToKeep = ["hu.dwim.defclass-star.asd"];
  overrides = x: x;
}
/* (SYSTEM hu.dwim.defclass-star DESCRIPTION
    Simplify class like definitions with defclass* and friends. SHA256
    032982lyp0hm0ssxlyh572whi2hr4j1nqkyqlllaj373v0dbs3vs URL
    http://beta.quicklisp.org/archive/hu.dwim.defclass-star/2015-07-09/hu.dwim.defclass-star-20150709-darcs.tgz
    MD5 e37f386dca8f789fb2e303a1914f0415 NAME hu.dwim.defclass-star FILENAME
    hu_dot_dwim_dot_defclass-star DEPS
    ((NAME hu.dwim.asdf FILENAME hu_dot_dwim_dot_asdf)) DEPENDENCIES
    (hu.dwim.asdf) VERSION 20150709-darcs SIBLINGS
    (hu.dwim.defclass-star+contextl hu.dwim.defclass-star+hu.dwim.def+contextl
     hu.dwim.defclass-star+hu.dwim.def hu.dwim.defclass-star+swank
     hu.dwim.defclass-star.documentation hu.dwim.defclass-star.test)
    PARASITES NIL) */
