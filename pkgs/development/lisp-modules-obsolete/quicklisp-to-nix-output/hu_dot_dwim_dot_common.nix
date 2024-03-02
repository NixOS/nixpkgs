/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "hu_dot_dwim_dot_common";
  version = "20150709-darcs";

  description = "An extended Common Lisp package to the general needs of other hu.dwim systems.";

  deps = [ args."alexandria" args."anaphora" args."closer-mop" args."hu_dot_dwim_dot_asdf" args."hu_dot_dwim_dot_common-lisp" args."iterate" args."metabang-bind" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/hu.dwim.common/2015-07-09/hu.dwim.common-20150709-darcs.tgz";
    sha256 = "12l1rr6w9m99w0b5gc6hv58ainjfhbc588kz6vwshn4gqsxyzbhp";
  };

  packageName = "hu.dwim.common";

  asdFilesToKeep = ["hu.dwim.common.asd"];
  overrides = x: x;
}
/* (SYSTEM hu.dwim.common DESCRIPTION
    An extended Common Lisp package to the general needs of other hu.dwim systems.
    SHA256 12l1rr6w9m99w0b5gc6hv58ainjfhbc588kz6vwshn4gqsxyzbhp URL
    http://beta.quicklisp.org/archive/hu.dwim.common/2015-07-09/hu.dwim.common-20150709-darcs.tgz
    MD5 fff7f05c24e71a0270021909ca86a9ef NAME hu.dwim.common FILENAME
    hu_dot_dwim_dot_common DEPS
    ((NAME alexandria FILENAME alexandria) (NAME anaphora FILENAME anaphora)
     (NAME closer-mop FILENAME closer-mop)
     (NAME hu.dwim.asdf FILENAME hu_dot_dwim_dot_asdf)
     (NAME hu.dwim.common-lisp FILENAME hu_dot_dwim_dot_common-lisp)
     (NAME iterate FILENAME iterate)
     (NAME metabang-bind FILENAME metabang-bind))
    DEPENDENCIES
    (alexandria anaphora closer-mop hu.dwim.asdf hu.dwim.common-lisp iterate
     metabang-bind)
    VERSION 20150709-darcs SIBLINGS (hu.dwim.common.documentation) PARASITES
    NIL) */
