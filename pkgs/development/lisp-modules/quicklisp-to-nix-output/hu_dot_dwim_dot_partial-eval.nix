/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "hu_dot_dwim_dot_partial-eval";
  version = "20171130-darcs";

  description = "Extensible partial evaluator.";

  deps = [ args."alexandria" args."anaphora" args."bordeaux-threads" args."closer-mop" args."contextl" args."hu_dot_dwim_dot_asdf" args."hu_dot_dwim_dot_common" args."hu_dot_dwim_dot_common-lisp" args."hu_dot_dwim_dot_def" args."hu_dot_dwim_dot_def_plus_contextl" args."hu_dot_dwim_dot_def_plus_hu_dot_dwim_dot_common" args."hu_dot_dwim_dot_defclass-star" args."hu_dot_dwim_dot_defclass-star_plus_contextl" args."hu_dot_dwim_dot_defclass-star_plus_hu_dot_dwim_dot_def" args."hu_dot_dwim_dot_defclass-star_plus_hu_dot_dwim_dot_def_plus_contextl" args."hu_dot_dwim_dot_logger" args."hu_dot_dwim_dot_syntax-sugar" args."hu_dot_dwim_dot_util" args."hu_dot_dwim_dot_util_slash_source" args."hu_dot_dwim_dot_walker" args."iterate" args."local-time" args."lw-compat" args."metabang-bind" args."swank" args."trivial-garbage" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/hu.dwim.partial-eval/2017-11-30/hu.dwim.partial-eval-20171130-darcs.tgz";
    sha256 = "1fw1lgxdif55viqrdqj4p5d936wipflavlk6cs2aj9hssm14nvqh";
  };

  packageName = "hu.dwim.partial-eval";

  asdFilesToKeep = ["hu.dwim.partial-eval.asd"];
  overrides = x: x;
}
/* (SYSTEM hu.dwim.partial-eval DESCRIPTION Extensible partial evaluator.
    SHA256 1fw1lgxdif55viqrdqj4p5d936wipflavlk6cs2aj9hssm14nvqh URL
    http://beta.quicklisp.org/archive/hu.dwim.partial-eval/2017-11-30/hu.dwim.partial-eval-20171130-darcs.tgz
    MD5 78c498a3ba353e0a62e15df49a459078 NAME hu.dwim.partial-eval FILENAME
    hu_dot_dwim_dot_partial-eval DEPS
    ((NAME alexandria FILENAME alexandria) (NAME anaphora FILENAME anaphora)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME closer-mop FILENAME closer-mop) (NAME contextl FILENAME contextl)
     (NAME hu.dwim.asdf FILENAME hu_dot_dwim_dot_asdf)
     (NAME hu.dwim.common FILENAME hu_dot_dwim_dot_common)
     (NAME hu.dwim.common-lisp FILENAME hu_dot_dwim_dot_common-lisp)
     (NAME hu.dwim.def FILENAME hu_dot_dwim_dot_def)
     (NAME hu.dwim.def+contextl FILENAME hu_dot_dwim_dot_def_plus_contextl)
     (NAME hu.dwim.def+hu.dwim.common FILENAME
      hu_dot_dwim_dot_def_plus_hu_dot_dwim_dot_common)
     (NAME hu.dwim.defclass-star FILENAME hu_dot_dwim_dot_defclass-star)
     (NAME hu.dwim.defclass-star+contextl FILENAME
      hu_dot_dwim_dot_defclass-star_plus_contextl)
     (NAME hu.dwim.defclass-star+hu.dwim.def FILENAME
      hu_dot_dwim_dot_defclass-star_plus_hu_dot_dwim_dot_def)
     (NAME hu.dwim.defclass-star+hu.dwim.def+contextl FILENAME
      hu_dot_dwim_dot_defclass-star_plus_hu_dot_dwim_dot_def_plus_contextl)
     (NAME hu.dwim.logger FILENAME hu_dot_dwim_dot_logger)
     (NAME hu.dwim.syntax-sugar FILENAME hu_dot_dwim_dot_syntax-sugar)
     (NAME hu.dwim.util FILENAME hu_dot_dwim_dot_util)
     (NAME hu.dwim.util/source FILENAME hu_dot_dwim_dot_util_slash_source)
     (NAME hu.dwim.walker FILENAME hu_dot_dwim_dot_walker)
     (NAME iterate FILENAME iterate) (NAME local-time FILENAME local-time)
     (NAME lw-compat FILENAME lw-compat)
     (NAME metabang-bind FILENAME metabang-bind) (NAME swank FILENAME swank)
     (NAME trivial-garbage FILENAME trivial-garbage))
    DEPENDENCIES
    (alexandria anaphora bordeaux-threads closer-mop contextl hu.dwim.asdf
     hu.dwim.common hu.dwim.common-lisp hu.dwim.def hu.dwim.def+contextl
     hu.dwim.def+hu.dwim.common hu.dwim.defclass-star
     hu.dwim.defclass-star+contextl hu.dwim.defclass-star+hu.dwim.def
     hu.dwim.defclass-star+hu.dwim.def+contextl hu.dwim.logger
     hu.dwim.syntax-sugar hu.dwim.util hu.dwim.util/source hu.dwim.walker
     iterate local-time lw-compat metabang-bind swank trivial-garbage)
    VERSION 20171130-darcs SIBLINGS
    (hu.dwim.partial-eval.documentation hu.dwim.partial-eval.test) PARASITES
    NIL) */
