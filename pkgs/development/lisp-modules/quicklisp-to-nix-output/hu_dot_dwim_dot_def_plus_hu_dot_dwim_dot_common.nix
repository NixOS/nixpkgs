/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "hu_dot_dwim_dot_def_plus_hu_dot_dwim_dot_common";
  version = "hu.dwim.def-stable-git";

  description = "System lacks description";

  deps = [ args."alexandria" args."anaphora" args."closer-mop" args."hu_dot_dwim_dot_asdf" args."hu_dot_dwim_dot_common" args."hu_dot_dwim_dot_common-lisp" args."hu_dot_dwim_dot_def" args."iterate" args."metabang-bind" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/hu.dwim.def/2021-12-30/hu.dwim.def-stable-git.tgz";
    sha256 = "1jmm9g2zacx3c6pd9v5ff1x5fzp9srz5844x0qpxj3bz9jfk2sgz";
  };

  packageName = "hu.dwim.def+hu.dwim.common";

  asdFilesToKeep = ["hu.dwim.def+hu.dwim.common.asd"];
  overrides = x: x;
}
/* (SYSTEM hu.dwim.def+hu.dwim.common DESCRIPTION System lacks description
    SHA256 1jmm9g2zacx3c6pd9v5ff1x5fzp9srz5844x0qpxj3bz9jfk2sgz URL
    http://beta.quicklisp.org/archive/hu.dwim.def/2021-12-30/hu.dwim.def-stable-git.tgz
    MD5 701fd28dce4536e91607fe5d2e1e8164 NAME hu.dwim.def+hu.dwim.common
    FILENAME hu_dot_dwim_dot_def_plus_hu_dot_dwim_dot_common DEPS
    ((NAME alexandria FILENAME alexandria) (NAME anaphora FILENAME anaphora)
     (NAME closer-mop FILENAME closer-mop)
     (NAME hu.dwim.asdf FILENAME hu_dot_dwim_dot_asdf)
     (NAME hu.dwim.common FILENAME hu_dot_dwim_dot_common)
     (NAME hu.dwim.common-lisp FILENAME hu_dot_dwim_dot_common-lisp)
     (NAME hu.dwim.def FILENAME hu_dot_dwim_dot_def)
     (NAME iterate FILENAME iterate)
     (NAME metabang-bind FILENAME metabang-bind))
    DEPENDENCIES
    (alexandria anaphora closer-mop hu.dwim.asdf hu.dwim.common
     hu.dwim.common-lisp hu.dwim.def iterate metabang-bind)
    VERSION hu.dwim.def-stable-git SIBLINGS
    (hu.dwim.def+cl-l10n hu.dwim.def+contextl hu.dwim.def+hu.dwim.delico
     hu.dwim.def+swank hu.dwim.def)
    PARASITES NIL) */
