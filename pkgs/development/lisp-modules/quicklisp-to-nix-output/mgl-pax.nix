args @ { fetchurl, ... }:
rec {
  baseName = ''mgl-pax'';
  version = ''20201016-git'';

  parasites = [ "mgl-pax/test" ];

  description = ''Exploratory programming tool and documentation
  generator.'';

  deps = [ args."_3bmd" args."_3bmd-ext-code-blocks" args."alexandria" args."babel" args."bordeaux-threads" args."cl-fad" args."colorize" args."esrap" args."html-encode" args."ironclad" args."named-readtables" args."pythonic-string-reader" args."split-sequence" args."swank" args."trivial-features" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/mgl-pax/2020-10-16/mgl-pax-20201016-git.tgz'';
    sha256 = ''0n48fw4a21sqy491bfi9fygrjl9psrryw00iha40dxy2ww86s6li'';
  };

  packageName = "mgl-pax";

  asdFilesToKeep = ["mgl-pax.asd"];
  overrides = x: x;
}
/* (SYSTEM mgl-pax DESCRIPTION Exploratory programming tool and documentation
  generator.
    SHA256 0n48fw4a21sqy491bfi9fygrjl9psrryw00iha40dxy2ww86s6li URL
    http://beta.quicklisp.org/archive/mgl-pax/2020-10-16/mgl-pax-20201016-git.tgz
    MD5 131fc5e8d8b86dc769917e468f502727 NAME mgl-pax FILENAME mgl-pax DEPS
    ((NAME 3bmd FILENAME _3bmd)
     (NAME 3bmd-ext-code-blocks FILENAME _3bmd-ext-code-blocks)
     (NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cl-fad FILENAME cl-fad) (NAME colorize FILENAME colorize)
     (NAME esrap FILENAME esrap) (NAME html-encode FILENAME html-encode)
     (NAME ironclad FILENAME ironclad)
     (NAME named-readtables FILENAME named-readtables)
     (NAME pythonic-string-reader FILENAME pythonic-string-reader)
     (NAME split-sequence FILENAME split-sequence) (NAME swank FILENAME swank)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES
    (3bmd 3bmd-ext-code-blocks alexandria babel bordeaux-threads cl-fad
     colorize esrap html-encode ironclad named-readtables
     pythonic-string-reader split-sequence swank trivial-features)
    VERSION 20201016-git SIBLINGS NIL PARASITES (mgl-pax/test)) */
