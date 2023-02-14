/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "hu_dot_dwim_dot_def_plus_swank";
  version = "hu.dwim.def-stable-git";

  description = "System lacks description";

  deps = [ args."alexandria" args."anaphora" args."hu_dot_dwim_dot_asdf" args."hu_dot_dwim_dot_def" args."iterate" args."metabang-bind" args."swank" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/hu.dwim.def/2021-12-30/hu.dwim.def-stable-git.tgz";
    sha256 = "1jmm9g2zacx3c6pd9v5ff1x5fzp9srz5844x0qpxj3bz9jfk2sgz";
  };

  packageName = "hu.dwim.def+swank";

  asdFilesToKeep = ["hu.dwim.def+swank.asd"];
  overrides = x: x;
}
/* (SYSTEM hu.dwim.def+swank DESCRIPTION System lacks description SHA256
    1jmm9g2zacx3c6pd9v5ff1x5fzp9srz5844x0qpxj3bz9jfk2sgz URL
    http://beta.quicklisp.org/archive/hu.dwim.def/2021-12-30/hu.dwim.def-stable-git.tgz
    MD5 701fd28dce4536e91607fe5d2e1e8164 NAME hu.dwim.def+swank FILENAME
    hu_dot_dwim_dot_def_plus_swank DEPS
    ((NAME alexandria FILENAME alexandria) (NAME anaphora FILENAME anaphora)
     (NAME hu.dwim.asdf FILENAME hu_dot_dwim_dot_asdf)
     (NAME hu.dwim.def FILENAME hu_dot_dwim_dot_def)
     (NAME iterate FILENAME iterate)
     (NAME metabang-bind FILENAME metabang-bind) (NAME swank FILENAME swank))
    DEPENDENCIES
    (alexandria anaphora hu.dwim.asdf hu.dwim.def iterate metabang-bind swank)
    VERSION hu.dwim.def-stable-git SIBLINGS
    (hu.dwim.def+cl-l10n hu.dwim.def+contextl hu.dwim.def+hu.dwim.common
     hu.dwim.def+hu.dwim.delico hu.dwim.def)
    PARASITES NIL) */
