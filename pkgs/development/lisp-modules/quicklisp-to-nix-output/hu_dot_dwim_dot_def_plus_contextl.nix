/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "hu_dot_dwim_dot_def_plus_contextl";
  version = "hu.dwim.def-stable-git";

  description = "System lacks description";

  deps = [ args."alexandria" args."anaphora" args."closer-mop" args."contextl" args."hu_dot_dwim_dot_asdf" args."hu_dot_dwim_dot_def" args."iterate" args."lw-compat" args."metabang-bind" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/hu.dwim.def/2021-12-30/hu.dwim.def-stable-git.tgz";
    sha256 = "1jmm9g2zacx3c6pd9v5ff1x5fzp9srz5844x0qpxj3bz9jfk2sgz";
  };

  packageName = "hu.dwim.def+contextl";

  asdFilesToKeep = ["hu.dwim.def+contextl.asd"];
  overrides = x: x;
}
/* (SYSTEM hu.dwim.def+contextl DESCRIPTION System lacks description SHA256
    1jmm9g2zacx3c6pd9v5ff1x5fzp9srz5844x0qpxj3bz9jfk2sgz URL
    http://beta.quicklisp.org/archive/hu.dwim.def/2021-12-30/hu.dwim.def-stable-git.tgz
    MD5 701fd28dce4536e91607fe5d2e1e8164 NAME hu.dwim.def+contextl FILENAME
    hu_dot_dwim_dot_def_plus_contextl DEPS
    ((NAME alexandria FILENAME alexandria) (NAME anaphora FILENAME anaphora)
     (NAME closer-mop FILENAME closer-mop) (NAME contextl FILENAME contextl)
     (NAME hu.dwim.asdf FILENAME hu_dot_dwim_dot_asdf)
     (NAME hu.dwim.def FILENAME hu_dot_dwim_dot_def)
     (NAME iterate FILENAME iterate) (NAME lw-compat FILENAME lw-compat)
     (NAME metabang-bind FILENAME metabang-bind))
    DEPENDENCIES
    (alexandria anaphora closer-mop contextl hu.dwim.asdf hu.dwim.def iterate
     lw-compat metabang-bind)
    VERSION hu.dwim.def-stable-git SIBLINGS
    (hu.dwim.def+cl-l10n hu.dwim.def+hu.dwim.common hu.dwim.def+hu.dwim.delico
     hu.dwim.def+swank hu.dwim.def)
    PARASITES NIL) */
