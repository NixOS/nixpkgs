/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "hu_dot_dwim_dot_logger";
  version = "stable-git";

  description = "Generic purpose logger utility.";

  deps = [ args."alexandria" args."anaphora" args."bordeaux-threads" args."closer-mop" args."hu_dot_dwim_dot_asdf" args."hu_dot_dwim_dot_common" args."hu_dot_dwim_dot_common-lisp" args."hu_dot_dwim_dot_def" args."hu_dot_dwim_dot_def_plus_hu_dot_dwim_dot_common" args."hu_dot_dwim_dot_def_slash_namespace" args."hu_dot_dwim_dot_defclass-star" args."hu_dot_dwim_dot_defclass-star_plus_hu_dot_dwim_dot_def" args."hu_dot_dwim_dot_syntax-sugar" args."hu_dot_dwim_dot_util" args."hu_dot_dwim_dot_util_slash_threads" args."iterate" args."local-time" args."metabang-bind" args."trivial-garbage" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/hu.dwim.logger/2021-12-30/hu.dwim.logger-stable-git.tgz";
    sha256 = "02dziwaayz1c9544ybp9sxr1ijk4vx6ixgiblnlr3vxn4lpwkjs6";
  };

  packageName = "hu.dwim.logger";

  asdFilesToKeep = ["hu.dwim.logger.asd"];
  overrides = x: x;
}
/* (SYSTEM hu.dwim.logger DESCRIPTION Generic purpose logger utility. SHA256
    02dziwaayz1c9544ybp9sxr1ijk4vx6ixgiblnlr3vxn4lpwkjs6 URL
    http://beta.quicklisp.org/archive/hu.dwim.logger/2021-12-30/hu.dwim.logger-stable-git.tgz
    MD5 8ad8efcd986ced0f2098bd8ab513efc8 NAME hu.dwim.logger FILENAME
    hu_dot_dwim_dot_logger DEPS
    ((NAME alexandria FILENAME alexandria) (NAME anaphora FILENAME anaphora)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME closer-mop FILENAME closer-mop)
     (NAME hu.dwim.asdf FILENAME hu_dot_dwim_dot_asdf)
     (NAME hu.dwim.common FILENAME hu_dot_dwim_dot_common)
     (NAME hu.dwim.common-lisp FILENAME hu_dot_dwim_dot_common-lisp)
     (NAME hu.dwim.def FILENAME hu_dot_dwim_dot_def)
     (NAME hu.dwim.def+hu.dwim.common FILENAME
      hu_dot_dwim_dot_def_plus_hu_dot_dwim_dot_common)
     (NAME hu.dwim.def/namespace FILENAME hu_dot_dwim_dot_def_slash_namespace)
     (NAME hu.dwim.defclass-star FILENAME hu_dot_dwim_dot_defclass-star)
     (NAME hu.dwim.defclass-star+hu.dwim.def FILENAME
      hu_dot_dwim_dot_defclass-star_plus_hu_dot_dwim_dot_def)
     (NAME hu.dwim.syntax-sugar FILENAME hu_dot_dwim_dot_syntax-sugar)
     (NAME hu.dwim.util FILENAME hu_dot_dwim_dot_util)
     (NAME hu.dwim.util/threads FILENAME hu_dot_dwim_dot_util_slash_threads)
     (NAME iterate FILENAME iterate) (NAME local-time FILENAME local-time)
     (NAME metabang-bind FILENAME metabang-bind)
     (NAME trivial-garbage FILENAME trivial-garbage))
    DEPENDENCIES
    (alexandria anaphora bordeaux-threads closer-mop hu.dwim.asdf
     hu.dwim.common hu.dwim.common-lisp hu.dwim.def hu.dwim.def+hu.dwim.common
     hu.dwim.def/namespace hu.dwim.defclass-star
     hu.dwim.defclass-star+hu.dwim.def hu.dwim.syntax-sugar hu.dwim.util
     hu.dwim.util/threads iterate local-time metabang-bind trivial-garbage)
    VERSION stable-git SIBLINGS
    (hu.dwim.logger+iolib hu.dwim.logger+swank hu.dwim.logger.documentation
     hu.dwim.logger.test)
    PARASITES NIL) */
