/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "hu_dot_dwim_dot_def";
  version = "stable-git";

  parasites = [ "hu.dwim.def/namespace" ];

  description = "General purpose, homogenous, extensible definer macro.";

  deps = [ args."alexandria" args."anaphora" args."bordeaux-threads" args."hu_dot_dwim_dot_asdf" args."hu_dot_dwim_dot_util" args."iterate" args."metabang-bind" args."trivial-garbage" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/hu.dwim.def/2021-12-30/hu.dwim.def-stable-git.tgz";
    sha256 = "1jmm9g2zacx3c6pd9v5ff1x5fzp9srz5844x0qpxj3bz9jfk2sgz";
  };

  packageName = "hu.dwim.def";

  asdFilesToKeep = ["hu.dwim.def.asd"];
  overrides = x: x;
}
/* (SYSTEM hu.dwim.def DESCRIPTION
    General purpose, homogenous, extensible definer macro. SHA256
    1jmm9g2zacx3c6pd9v5ff1x5fzp9srz5844x0qpxj3bz9jfk2sgz URL
    http://beta.quicklisp.org/archive/hu.dwim.def/2021-12-30/hu.dwim.def-stable-git.tgz
    MD5 701fd28dce4536e91607fe5d2e1e8164 NAME hu.dwim.def FILENAME
    hu_dot_dwim_dot_def DEPS
    ((NAME alexandria FILENAME alexandria) (NAME anaphora FILENAME anaphora)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME hu.dwim.asdf FILENAME hu_dot_dwim_dot_asdf)
     (NAME hu.dwim.util FILENAME hu_dot_dwim_dot_util)
     (NAME iterate FILENAME iterate)
     (NAME metabang-bind FILENAME metabang-bind)
     (NAME trivial-garbage FILENAME trivial-garbage))
    DEPENDENCIES
    (alexandria anaphora bordeaux-threads hu.dwim.asdf hu.dwim.util iterate
     metabang-bind trivial-garbage)
    VERSION stable-git SIBLINGS
    (hu.dwim.def+cl-l10n hu.dwim.def+contextl hu.dwim.def+hu.dwim.common
     hu.dwim.def+hu.dwim.delico hu.dwim.def+swank)
    PARASITES (hu.dwim.def/namespace)) */
