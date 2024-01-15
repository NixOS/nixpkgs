/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "hu_dot_dwim_dot_def_plus_swank";
  version = "hu.dwim.def-20201016-darcs";

  description = "System lacks description";

  deps = [ args."alexandria" args."anaphora" args."hu_dot_dwim_dot_asdf" args."hu_dot_dwim_dot_def" args."iterate" args."metabang-bind" args."swank" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/hu.dwim.def/2020-10-16/hu.dwim.def-20201016-darcs.tgz";
    sha256 = "0m9id405f0s1438yr2qppdw5z7xdx3ajaa1frd04pibqgf4db4cj";
  };

  packageName = "hu.dwim.def+swank";

  asdFilesToKeep = ["hu.dwim.def+swank.asd"];
  overrides = x: x;
}
/* (SYSTEM hu.dwim.def+swank DESCRIPTION System lacks description SHA256
    0m9id405f0s1438yr2qppdw5z7xdx3ajaa1frd04pibqgf4db4cj URL
    http://beta.quicklisp.org/archive/hu.dwim.def/2020-10-16/hu.dwim.def-20201016-darcs.tgz
    MD5 c4d7469472f57cd700d8319e35dd5f32 NAME hu.dwim.def+swank FILENAME
    hu_dot_dwim_dot_def_plus_swank DEPS
    ((NAME alexandria FILENAME alexandria) (NAME anaphora FILENAME anaphora)
     (NAME hu.dwim.asdf FILENAME hu_dot_dwim_dot_asdf)
     (NAME hu.dwim.def FILENAME hu_dot_dwim_dot_def)
     (NAME iterate FILENAME iterate)
     (NAME metabang-bind FILENAME metabang-bind) (NAME swank FILENAME swank))
    DEPENDENCIES
    (alexandria anaphora hu.dwim.asdf hu.dwim.def iterate metabang-bind swank)
    VERSION hu.dwim.def-20201016-darcs SIBLINGS
    (hu.dwim.def+cl-l10n hu.dwim.def+contextl hu.dwim.def+hu.dwim.common
     hu.dwim.def+hu.dwim.delico hu.dwim.def hu.dwim.def.documentation
     hu.dwim.def.namespace hu.dwim.def.test)
    PARASITES NIL) */
