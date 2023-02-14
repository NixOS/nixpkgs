/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "hu_dot_dwim_dot_walker";
  version = "stable-git";

  parasites = [ "hu.dwim.walker/test" ];

  description = "Common Lisp form walker and unwalker (to and from CLOS instances).";

  deps = [ args."alexandria" args."anaphora" args."closer-mop" args."contextl" args."hu_dot_dwim_dot_asdf" args."hu_dot_dwim_dot_common" args."hu_dot_dwim_dot_common-lisp" args."hu_dot_dwim_dot_def" args."hu_dot_dwim_dot_def_plus_contextl" args."hu_dot_dwim_dot_def_plus_hu_dot_dwim_dot_common" args."hu_dot_dwim_dot_defclass-star" args."hu_dot_dwim_dot_defclass-star_plus_hu_dot_dwim_dot_def" args."hu_dot_dwim_dot_stefil_plus_hu_dot_dwim_dot_def" args."hu_dot_dwim_dot_stefil_plus_swank" args."hu_dot_dwim_dot_syntax-sugar" args."hu_dot_dwim_dot_util" args."hu_dot_dwim_dot_util_slash_temporary-files" args."iolib_slash_os" args."iterate" args."lw-compat" args."metabang-bind" args."swank" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/hu.dwim.walker/2021-02-28/hu.dwim.walker-stable-git.tgz";
    sha256 = "02dy46dc422531bq2y7rd75c6j0fgidplgkcwyhp0a2dqrisywjz";
  };

  packageName = "hu.dwim.walker";

  asdFilesToKeep = ["hu.dwim.walker.asd"];
  overrides = x: x;
}
/* (SYSTEM hu.dwim.walker DESCRIPTION
    Common Lisp form walker and unwalker (to and from CLOS instances). SHA256
    02dy46dc422531bq2y7rd75c6j0fgidplgkcwyhp0a2dqrisywjz URL
    http://beta.quicklisp.org/archive/hu.dwim.walker/2021-02-28/hu.dwim.walker-stable-git.tgz
    MD5 27371190d8fd780827efca6e669b8915 NAME hu.dwim.walker FILENAME
    hu_dot_dwim_dot_walker DEPS
    ((NAME alexandria FILENAME alexandria) (NAME anaphora FILENAME anaphora)
     (NAME closer-mop FILENAME closer-mop) (NAME contextl FILENAME contextl)
     (NAME hu.dwim.asdf FILENAME hu_dot_dwim_dot_asdf)
     (NAME hu.dwim.common FILENAME hu_dot_dwim_dot_common)
     (NAME hu.dwim.common-lisp FILENAME hu_dot_dwim_dot_common-lisp)
     (NAME hu.dwim.def FILENAME hu_dot_dwim_dot_def)
     (NAME hu.dwim.def+contextl FILENAME hu_dot_dwim_dot_def_plus_contextl)
     (NAME hu.dwim.def+hu.dwim.common FILENAME
      hu_dot_dwim_dot_def_plus_hu_dot_dwim_dot_common)
     (NAME hu.dwim.defclass-star FILENAME hu_dot_dwim_dot_defclass-star)
     (NAME hu.dwim.defclass-star+hu.dwim.def FILENAME
      hu_dot_dwim_dot_defclass-star_plus_hu_dot_dwim_dot_def)
     (NAME hu.dwim.stefil+hu.dwim.def FILENAME
      hu_dot_dwim_dot_stefil_plus_hu_dot_dwim_dot_def)
     (NAME hu.dwim.stefil+swank FILENAME hu_dot_dwim_dot_stefil_plus_swank)
     (NAME hu.dwim.syntax-sugar FILENAME hu_dot_dwim_dot_syntax-sugar)
     (NAME hu.dwim.util FILENAME hu_dot_dwim_dot_util)
     (NAME hu.dwim.util/temporary-files FILENAME
      hu_dot_dwim_dot_util_slash_temporary-files)
     (NAME iolib/os FILENAME iolib_slash_os) (NAME iterate FILENAME iterate)
     (NAME lw-compat FILENAME lw-compat)
     (NAME metabang-bind FILENAME metabang-bind) (NAME swank FILENAME swank))
    DEPENDENCIES
    (alexandria anaphora closer-mop contextl hu.dwim.asdf hu.dwim.common
     hu.dwim.common-lisp hu.dwim.def hu.dwim.def+contextl
     hu.dwim.def+hu.dwim.common hu.dwim.defclass-star
     hu.dwim.defclass-star+hu.dwim.def hu.dwim.stefil+hu.dwim.def
     hu.dwim.stefil+swank hu.dwim.syntax-sugar hu.dwim.util
     hu.dwim.util/temporary-files iolib/os iterate lw-compat metabang-bind
     swank)
    VERSION stable-git SIBLINGS NIL PARASITES (hu.dwim.walker/test)) */
