/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "hu_dot_dwim_dot_util";
  version = "stable-git";

  parasites = [ "hu.dwim.util/authorization" "hu.dwim.util/command-line" "hu.dwim.util/error-handling" "hu.dwim.util/error-handling+swank" "hu.dwim.util/finite-state-machine" "hu.dwim.util/flexml" ];

  description = "Various utilities, this is the most basic system that only introduce a small number of external dependencies.";

  deps = [ args."alexandria" args."anaphora" args."cl-ppcre" args."closer-mop" args."command-line-arguments" args."cxml" args."hu_dot_dwim_dot_asdf" args."hu_dot_dwim_dot_common" args."hu_dot_dwim_dot_common-lisp" args."hu_dot_dwim_dot_def" args."hu_dot_dwim_dot_def_plus_hu_dot_dwim_dot_common" args."hu_dot_dwim_dot_def_slash_namespace" args."hu_dot_dwim_dot_defclass-star" args."hu_dot_dwim_dot_defclass-star_plus_hu_dot_dwim_dot_def" args."hu_dot_dwim_dot_logger" args."hu_dot_dwim_dot_partial-eval" args."hu_dot_dwim_dot_syntax-sugar" args."hu_dot_dwim_dot_walker" args."iterate" args."metabang-bind" args."swank" args."uiop" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/hu.dwim.util/2021-12-30/hu.dwim.util-stable-git.tgz";
    sha256 = "1nm0q9cyhkwy4w0867ayiz4wn98mm6hzl9ifp1a5p8k458d37y2s";
  };

  packageName = "hu.dwim.util";

  asdFilesToKeep = ["hu.dwim.util.asd"];
  overrides = x: x;
}
/* (SYSTEM hu.dwim.util DESCRIPTION
    Various utilities, this is the most basic system that only introduce a small number of external dependencies.
    SHA256 1nm0q9cyhkwy4w0867ayiz4wn98mm6hzl9ifp1a5p8k458d37y2s URL
    http://beta.quicklisp.org/archive/hu.dwim.util/2021-12-30/hu.dwim.util-stable-git.tgz
    MD5 62ee64d5aa5cfd150f5f471cd976427f NAME hu.dwim.util FILENAME
    hu_dot_dwim_dot_util DEPS
    ((NAME alexandria FILENAME alexandria) (NAME anaphora FILENAME anaphora)
     (NAME cl-ppcre FILENAME cl-ppcre) (NAME closer-mop FILENAME closer-mop)
     (NAME command-line-arguments FILENAME command-line-arguments)
     (NAME cxml FILENAME cxml)
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
     (NAME hu.dwim.logger FILENAME hu_dot_dwim_dot_logger)
     (NAME hu.dwim.partial-eval FILENAME hu_dot_dwim_dot_partial-eval)
     (NAME hu.dwim.syntax-sugar FILENAME hu_dot_dwim_dot_syntax-sugar)
     (NAME hu.dwim.walker FILENAME hu_dot_dwim_dot_walker)
     (NAME iterate FILENAME iterate)
     (NAME metabang-bind FILENAME metabang-bind) (NAME swank FILENAME swank)
     (NAME uiop FILENAME uiop))
    DEPENDENCIES
    (alexandria anaphora cl-ppcre closer-mop command-line-arguments cxml
     hu.dwim.asdf hu.dwim.common hu.dwim.common-lisp hu.dwim.def
     hu.dwim.def+hu.dwim.common hu.dwim.def/namespace hu.dwim.defclass-star
     hu.dwim.defclass-star+hu.dwim.def hu.dwim.logger hu.dwim.partial-eval
     hu.dwim.syntax-sugar hu.dwim.walker iterate metabang-bind swank uiop)
    VERSION stable-git SIBLINGS
    (hu.dwim.util+iolib hu.dwim.util.documentation hu.dwim.util.test) PARASITES
    (hu.dwim.util/authorization hu.dwim.util/command-line
     hu.dwim.util/error-handling hu.dwim.util/error-handling+swank
     hu.dwim.util/finite-state-machine hu.dwim.util/flexml)) */
